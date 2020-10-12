# frozen_string_literal: true

module TiddlyBlogger
  class ConvertBlog
    # @param [BloggerGateway] blogger
    # @param [Converter] converter
    def initialize(blogger:, converter: BlogConverter.new)
      @blogger = blogger
      @blog_converter = converter
    end

    # @param [BlogConversionRequest] convert_blog_request
    def execute(convert_blog_request)
      blog = blog_with_posts(convert_blog_request.blog_url)

      tiddlywiki_container = @blog_converter.convert(blog)

      BlogConversionResponse.new(
        convert_blog_request,
        tiddlywiki_container,
        blog: blog
      )
    end

    def blog_with_posts(blog_url)
      blog_hash = @blogger.get_blog_by_url(blog_url)
      blog = Blog.new(blog_hash)
      blog.posts = @blogger.get_posts_by_blog_id_as_posts(blog.blog_id)
      blog
    end
  end
end
