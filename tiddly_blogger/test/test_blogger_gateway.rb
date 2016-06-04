# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'

require 'tiddly_blogger'

module TiddlyBlogger
  class BloggerGatewayTest < MiniTest::Spec
    # TEST_URL = 'http://barefoot-food.blogspot.ca/'
    TEST_URL = 'http://shadowradiance-lyrics.blogspot.com'
    # TEST_ID = 7942290902909142963
    TEST_ID = 1_521_384_701_098_992_626 # SR Lyrics
    API_KEY = ENV['BLOGGER_API_KEY']

    def initialize(name)
      super
      @blogger_gateway = BloggerGateway.new(API_KEY)
    end

    def setup; end

    def test_can_connect
      slow_test

      blog = @blogger_gateway.get_blog_by_url TEST_URL
      expect(blog).wont_be_nil
    end

    def test_get_blog_by_url
      slow_test

      blog = @blogger_gateway.get_blog_by_url TEST_URL
      expect(blog).must_be_instance_of HashWithIndifferentAccess
      expect(blog[:posts]).must_be_instance_of HashWithIndifferentAccess
    end

    def test_get_posts_by_blog_id
      slow_test

      posts = @blogger_gateway.get_posts_by_blog_id TEST_ID
      expect(posts).must_be_instance_of HashWithIndifferentAccess
      expect(posts[:items]).must_be_instance_of Array
      posts[:items].each do |post|
        expect(post).must_be_instance_of HashWithIndifferentAccess
      end
    end

    def test_get_posts_by_blog_id_as_posts
      slow_test

      posts = @blogger_gateway.get_posts_by_blog_id_as_posts TEST_ID
      expect(posts).must_be_instance_of Posts
      posts.each do |post|
        expect(post).must_be_instance_of Post
      end
    end

    def test_get_blog_by_url_as_blog_with_posts
      slow_test

      full_posts = @blogger_gateway.get_blog_by_url_as_blog_with_posts TEST_URL
      expect(full_posts).must_be_instance_of Blog
      expect(full_posts.posts).must_be_instance_of Posts
    end

    def test_get_posts_by_blog_id_gets_all_posts
      slow_test

      full_posts = @blogger_gateway.get_blog_by_url_as_blog_with_posts TEST_URL
      expect(full_posts.posts.size).must_equal full_posts.posts_count
    end

    private

    def slow_test
      msg = 'This is a slow test'
      skip msg unless ENV['SLOW_TESTS']
    end
  end
end
