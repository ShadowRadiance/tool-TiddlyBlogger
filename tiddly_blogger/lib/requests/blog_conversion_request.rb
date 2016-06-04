# frozen_string_literal: true

module TiddlyBlogger
  class BlogConversionRequest
    attr_accessor :blog_url

    def initialize(blog_url:)
      self.blog_url = blog_url
    end
  end
end
