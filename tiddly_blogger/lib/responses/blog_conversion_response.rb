# frozen_string_literal: true

module TiddlyBlogger
  class BlogConversionResponse
    attr_reader :tiddlywiki_container

    def initialize(blog_conversion_request, tiddlywiki_container)
      @blog_conversion_request = blog_conversion_request
      @tiddlywiki_container = tiddlywiki_container
    end

    def blog_url
      @blog_conversion_request.blog_url
    end
  end
end
