# frozen_string_literal: true

require "webrick"
require "fileutils"

root = if !ARGV.empty?
  ARGV.first.tr("\\", "/")
else
  "."
end
BACKUP_DIR = "bak"

# rubocop:disable Naming/MethodName
module WEBrick
  module HTTPServlet
    class FileHandler
      alias_method :do_PUT, :do_GET
    end

    class DefaultFileHandler
      def do_PUT(req, res)
        file = "#{@config[:DocumentRoot]}#{req.path}"
        res.body = ""
        Dir.mkdir BACKUP_DIR unless Dir.exist? BACKUP_DIR
        FileUtils.cp(file, "#{BACKUP_DIR}/#{File.basename(file, ".html")}.#{Time.now.to_i}.html")
        File.open(file, "w+") { |f| f.puts(req.body) }
      end

      def do_OPTIONS(_req, res)
        res["allow"] = "GET,HEAD,POST,OPTIONS,CONNECT,PUT,DAV,dav"
        res["x-api-access-type"] = "file"
        res["dav"] = "tw5/put"
      end
    end
  end
end
# rubocop:enable Naming/MethodName

server = WEBrick::HTTPServer.new({Port: 8000, DocumentRoot: root})

trap "INT" do
  puts "Shutting down..."
  server.shutdown
end

server.start
