# frozen_string_literal: true

require_relative "base"

module TiddlyWikiOutput
  class SiteSubtitle < Base
    def initialize(blog)
      super()
      @blog = blog
    end

    def tiddler_heading
      {
        created: now.strftime(TIME_FORMAT),
        modified: now.strftime(TIME_FORMAT),
        title: "$:/SiteSubtitle"
      }
    end

    def tiddler_content
      "Blog exported from #{blog_name}"
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
