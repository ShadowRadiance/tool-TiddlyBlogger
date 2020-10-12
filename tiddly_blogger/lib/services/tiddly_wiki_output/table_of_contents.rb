# frozen_string_literal: true

require 'time'
require 'htmlentities'
require_relative 'base'

module TiddlyWikiOutput
  class TableOfContents < Base
    def initialize(blog)
      super()
      @blog = blog
    end

    def tiddler_heading
      {
        created: now.strftime(TIME_FORMAT),
        modified: now.strftime(TIME_FORMAT),
        tags: '',
        title: "Blog Posts from #{blog_name}"
      }
    end

    def tiddler_content
      @html_coder.encode('<<timeline format:"DD/MM/YYYY" subfilter:"!<storyTiddler>;">>')
    end

    private

    def blog_name
      @html_coder.encode(@blog.name)
    end

    def now
      @now ||= Time.now.utc
    end
  end
end
