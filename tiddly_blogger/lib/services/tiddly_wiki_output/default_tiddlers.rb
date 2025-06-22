# frozen_string_literal: true

require_relative "base"

module TiddlyWikiOutput
  class DefaultTiddlersTiddler < Base
    def initialize(blog)
      super()
      @blog = blog
    end

    def tiddler_heading
      {
        created: now.strftime(TIME_FORMAT),
        modified: now.strftime(TIME_FORMAT),
        title: "$:/DefaultTiddlers"
      }
    end

    def tiddler_content
      @html_coder.encode("[[Blog Posts from #{blog_name}]]")
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
