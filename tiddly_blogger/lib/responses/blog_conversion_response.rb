# frozen_string_literal: true

module TiddlyBlogger
  class BlogConversionResponse
    attr_reader :blog_conversion_request, :tiddlywiki_container, :blog

    def initialize(blog_conversion_request, tiddlywiki_container, blog: nil)
      @blog_conversion_request = blog_conversion_request
      @tiddlywiki_container = tiddlywiki_container
      @blog = blog
    end
  end
end
