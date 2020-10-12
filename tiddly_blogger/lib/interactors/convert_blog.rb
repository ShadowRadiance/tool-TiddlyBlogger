# frozen_string_literal: true

module TiddlyBlogger
  class ConvertBlog
    TIME_FORMAT = '%Y%m%d%H%M%S%L'

    # @param [BloggerGateway] blogger
    # @param [Converter] converter
    def initialize(blogger:, converter: BlogConverter.new)
      @blogger = blogger
      @blog_converter = converter
    end

    # @param [BlogConversionRequest] convert_blog_request
    def execute(convert_blog_request)
      blog = blog_with_posts(convert_blog_request.blog_url)

      temp_file = "data/blog-#{blog.id}-#{Time.now.utc.strftime(TIME_FORMAT)}.html"

      @blog_converter.convert(blog, temp_file)

      BlogConversionResponse.new(
        convert_blog_request,
        file_name: temp_file,
        blog: blog
      )
    end

    def blog_with_posts(blog_url)
      blog_hash = @blogger.get_blog_by_url(blog_url)
      blog = Blog.new(blog_hash)
      blog.posts = @blogger.get_posts_by_blog_id_as_posts(blog.id)
      blog
    end
  end
end
