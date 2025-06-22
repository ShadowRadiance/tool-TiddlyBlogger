# frozen_string_literal: true

module TiddlyBlogger
  class BlogConversionResponse
    attr_reader :blog_conversion_request, :file_name, :blog

    def initialize(blog_conversion_request, file_name: nil, blog: nil)
      @blog_conversion_request = blog_conversion_request
      @file_name = file_name || "STDOUT"
      @blog = blog
    end
  end
end
