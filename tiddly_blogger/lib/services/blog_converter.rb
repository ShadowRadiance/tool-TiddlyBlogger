# frozen_string_literal: true

require 'time'
require 'htmlentities'

require_relative 'tiddly_wiki_output/site_title'
require_relative 'tiddly_wiki_output/site_subtitle'
require_relative 'tiddly_wiki_output/default_tiddlers'
require_relative 'tiddly_wiki_output/table_of_contents'
require_relative 'tiddly_wiki_output/tiddler'
require_relative 'tiddly_wiki_output/theme'
require_relative 'tiddly_wiki_output/view'

module TiddlyBlogger
  class BlogConverter
    def convert(blog, to_file = nil)
      @blog = blog
      if to_file != $stdout
        File.open(to_file, 'w') do |o|
          write_output_to(o)
        end
      else
        write_output_to($stdout)
      end
    ensure
      @blog = nil
    end

    def write_output_to(output)
      skipping_until_end = false
      File.foreach('data/empty-gb.html') do |line|
        skipping_until_end = false if line =~ /<!-- END CUSTOM TIDDLERS -->/
        output.write(line) unless skipping_until_end
        if line =~ /<!-- BEGIN CUSTOM TIDDLERS -->/
          output.write(custom_tiddlers.join("\n"))
          skipping_until_end = true
        end
      end
    end

    def custom_tiddlers
      [
        TiddlyWikiOutput::DefaultTiddlersTiddler.new(@blog).to_s,
        TiddlyWikiOutput::SiteSubtitle.new(@blog).to_s,
        TiddlyWikiOutput::SiteTitle.new.to_s,
        TiddlyWikiOutput::TableOfContents.new(@blog).to_s,
        TiddlyWikiOutput::Theme.new.to_s,
        TiddlyWikiOutput::View.new.to_s,
        @blog.posts.map { |post| TiddlyWikiOutput::Tiddler.new(post).to_s }
      ]
    end
  end
end
