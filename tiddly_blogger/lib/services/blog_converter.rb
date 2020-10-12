# frozen_string_literal: true

require 'time'
require 'htmlentities'

require_relative 'tiddly_wiki_output/table_of_contents'
require_relative 'tiddly_wiki_output/tiddler'

module TiddlyBlogger
  class BlogConverter
    def convert(blog)
      {
        table_of_contents: TiddlyWikiOutput::TableOfContents.new(blog).to_s,
        tiddlers: blog.posts.map do |post|
                    TiddlyWikiOutput::Tiddler.new(post).to_s
                  end
      }
    end
  end
end
