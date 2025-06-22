# frozen_string_literal: true

require "test_helper"

module TiddlyBlogger
  class BlogTest < Minitest::Test
    def setup
    end

    # rubocop:disable Metrics/MethodLength
    def good_data
      {
        kind: "blogger#blog",
        id: "1521384701098992626",
        name: "ShadowRadiance... Lyrics",
        description: "",
        published: "2008-05-07T12:33:30-07:00",
        updated: "2014-10-05T00:59:01-07:00",
        url: "http://shadowradiance-lyrics.blogspot.com/",
        selfLink: "https://www.googleapis.com/blogger/v3/blogs/1521384701098992626",
        posts: {
          totalItems: 6,
          selfLink: "https://www.googleapis.com/blogger/v3/blogs/1521384701098992626/posts"
        },
        pages: {
          totalItems: 0,
          selfLink: "https://www.googleapis.com/blogger/v3/blogs/1521384701098992626/pages"
        },
        locale: {
          language: "en",
          country: "",
          variant: ""
        }
      }
    end
    # rubocop:enable Metrics/MethodLength

    def test_initialize_with_good_data
      post = Blog.new good_data
      assert_instance_of Blog, post
      assert_equal post.name, "ShadowRadiance... Lyrics"
      assert_equal post.description, ""
      assert_equal post.url, "http://shadowradiance-lyrics.blogspot.com/"
      assert_equal post.posts_count, 6
      assert_equal post.pages_count, 0
    end

    # def test_initialize_with_no_name
    #   assert_raises NoMethodError do
    #     Blog.new(good_data.reject { |k, _v| k == 'name' })
    #   end
    # end

    # def test_initialize_with_no_posts
    #   assert_raises NoMethodError do
    #     Blog.new(good_data.reject { |k, _v| k == 'posts' })
    #   end
    # end
  end
end
