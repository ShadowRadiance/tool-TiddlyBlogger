# frozen_string_literal: true

require "test_helper"

module TiddlyBlogger
  class ConvertBlogTest < Minitest::Test
    BLOG_URL = "http://shadowradiance.blogger.com"

    def setup
      @blogger = Minitest::Mock.new
      @convert_blog = ConvertBlog.new blogger: @blogger
    end

    def test_convert_blog
      @blogger.expect(:get_blog_by_url, valid_blog_data, [String])
      @blogger.expect(:get_posts_by_blog_id_as_posts, Posts.new([]), [String])

      @convert_blog.execute blog_conversion_request

      @blogger.verify
    end

    def valid_blog
      Blog.new(valid_blog_data)
    end

    def valid_blog_data
      {
        id: "1521384701098992626",
        name: "ShadowRadiance... Lyrics",
        description: "",
        url: "http://shadowradiance-lyrics.blogspot.com/",
        posts: {totalItems: 6},
        pages: {totalItems: 0}
      }
    end

    private

    def blog_conversion_request
      BlogConversionRequest.new blog_url: BLOG_URL
    end
  end
end
