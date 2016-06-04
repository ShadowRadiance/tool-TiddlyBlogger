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
    def convert_blog(convert_blog_request)
      blog = blog_with_posts(convert_blog_request.blog_url)

      tiddlywiki_container = @blog_converter.convert blog

      BlogConversionResponse.new(convert_blog_request, tiddlywiki_container)
    end

    def blog_with_posts(blog_url)
      @blogger.get_blog_by_url(blog_url).tap do |blog|
        blog.posts = @blogger.get_posts_by_blog_id blog.blog_id
      end
    end
  end

  # <div created="20160601003309428"
  #      modified="20160601003348323"
  #      tags="[[Tag Goes Here]] [[Another Tag]]"
  #      title="Tiddler Number Two"
  #      type="">
  # <pre>Tiddler Wiki Text Goes Here
  #
  # With Multiple Lines (No Content Type)</pre>
  # </div>
end
