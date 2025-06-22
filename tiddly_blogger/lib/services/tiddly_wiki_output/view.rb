# frozen_string_literal: true

require_relative "base"

module TiddlyWikiOutput
  class View < Base
    def tiddler_heading
      {
        created: now.strftime(TIME_FORMAT),
        modified: now.strftime(TIME_FORMAT),
        title: "$:/view"
      }
    end

    def pre
      "<pre>#{yield}</pre>"
    end

    def tiddler_content
      ENV["VIEW"] || "classic"
    end

    private

    def now
      @now ||= Time.now.utc
    end
  end
end
