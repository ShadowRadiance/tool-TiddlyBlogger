# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'

require 'tiddly_blogger'

module TiddlyBlogger
  class ConvertBlogTest < MiniTest::Test
    BLOG_URL = 'http://shadowradiance.blogger.com'

    def setup
      @blogger      = mock
      @convert_blog = ConvertBlog.new blogger: @blogger
    end

    def test_convert_blog
      @blogger.expects(:get_blog_by_url).returns(valid_blog).at_least_once
      @blogger.expects(:get_posts_by_blog_id).returns([]).at_least_once

      @convert_blog.execute blog_conversion_request
    end

    def valid_blog
      Blog.new(valid_blog_data)
    end

    def valid_blog_data
      {
        'id': '1521384701098992626',
        'name': 'ShadowRadiance... Lyrics',
        'description': '',
        'url': 'http://shadowradiance-lyrics.blogspot.com/',
        'posts': { 'totalItems': 6 },
        'pages': { 'totalItems': 0 }
      }
    end

    private

    def blog_conversion_request
      BlogConversionRequest.new blog_url: BLOG_URL
    end
  end
end
