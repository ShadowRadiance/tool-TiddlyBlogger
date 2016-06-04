# frozen_string_literal: true

require 'net/http'
require 'json'
require 'active_support/cache'
require 'active_support/core_ext/hash/indifferent_access'

module TiddlyBlogger
  class BloggerGateway
    BLOG_BY_URL      = 'https://www.googleapis.com/blogger/v3/blogs/byurl'
    POSTS_BY_BLOG_ID = 'https://www.googleapis.com/blogger/v3/blogs/%<blog_id>/posts'

    def initialize(api_key)
      @cache = ActiveSupport::Cache::MemoryStore.new
      @api_key = api_key
    end

    def verify_existence_of(blog_url)
      !get_blog_by_url(blog_url).nil?
    end

    def get_blog_by_url(blog_url)
      rest_call(url_for_blog_by_url(blog_url))
    end

    def get_blog_by_url_as_blog(blog_url)
      blog_params = get_blog_by_url(blog_url)
      Blog.new(blog_params) if blog_params
    end

    def get_blog_by_url_as_blog_with_posts(blog_url)
      blog = get_blog_by_url_as_blog blog_url
      posts = get_posts_by_blog_id_as_posts(blog.blog_id)
      blog.posts = posts
      blog
    end

    def get_posts_by_blog_id(blog_id, page_token = nil)
      @cache.fetch("#{blog_id}/token/#{page_token}") do
        rest_call(url_for_posts_list(blog_id, page_token))
      end
    end

    # rubocop:disable Metrics/MethodLength
    def get_posts_by_blog_id_as_posts(blog_id)
      @cache.fetch("#{blog_id}/") do
        posts_params_items = []
        posts_params_continue = get_posts_by_blog_id(blog_id)
        while posts_params_continue[:items]&.length&.positive?
          posts_params_items.concat posts_params_continue[:items]

          next_page_token = posts_params_continue[:nextPageToken]

          break unless next_page_token

          posts_params_continue = get_posts_by_blog_id(blog_id, next_page_token)
        end

        Posts.new(posts_params_items)
      end
    end
    # rubocop:enable Metrics/MethodLength

    def url_for_posts_list(blog_id, page_token = nil)
      params = { key: @api_key }
      params[:pageToken] = page_token if page_token
      append_params_to_uri(format(POSTS_BY_BLOG_ID, { blog_id: blog_id }), params)

      # 200 - found
      # 404 - not found

      # body is JSON either:
      # {
      #     "error": {
      #         "errors": [ { "domain": "global", "reason": "notFound", "message": "Not Found" } ],
      #         "code": 404,
      #         "message": "Not Found"
      #     }
      # }
      # or something like
      # {
      #     "kind": "blogger#postList",
      #     "nextPageToken": string,
      #     "items": [
      #         {
      #             "kind": "blogger#post",
      #             "id": string,
      #             "blog": { "id": string },
      #             "published": datetime,
      #             "updated": datetime,
      #             "url": string,
      #             "selfLink": string,
      #             "title": string,
      #             "titleLink": string,
      #             "content": string,
      #             "images": [
      #                 { "url": string },
      #                 ...
      #             ],
      #             "customMetaData": string,
      #             "author": {
      #                 "id": string,
      #                 "displayName": string,
      #                 "url": string,
      #                 "image": {
      #                     "url": string
      #                 }
      #             },
      #             "replies": {
      #                 "totalItems": long,
      #                 "selfLink": string,
      #                 "items": [
      #                     comments Resource,
      #                     ...
      #                 ]
      #             },
      #             "labels": [ string, ... ],
      #             "location": {
      #                 "name": string,
      #                 "lat": double,
      #                 "lng": double,
      #                 "span": string
      #             },
      #             "status": string
      #         },
      #         ...
      #     ]
      # }
    end

    def url_for_blog_by_url(blog_url)
      append_params_to_uri(BLOG_BY_URL, { url: blog_url, key: @api_key })

      # 200 - found
      # 404 - not found

      # body is JSON either:
      # {
      #     "error": {
      #         "errors": [ { "domain": "global", "reason": "notFound", "message": "Not Found" } ],
      #         "code": 404,
      #         "message": "Not Found"
      #     }
      # }
      # or something like
      # {
      #     "kind": "blogger#blog",
      #     "id": "3835840683626140337",
      #     "name": "ShadowRadiance",
      #     "description": "",
      #     "published": "2008-03-18T16:55:03-07:00",
      #     "updated": "2014-10-04T20:01:34-07:00",
      #     "url": "http://shadowradiance.blogspot.com/",
      #     "selfLink": "https://www.googleapis.com/blogger/v3/blogs/3835840683626140337",
      #     "posts": {
      #         "totalItems": 1,
      #         "selfLink": "https://www.googleapis.com/blogger/v3/blogs/3835840683626140337/posts"
      #     },
      #     "pages": {
      #         "totalItems": 0,
      #         "selfLink": "https://www.googleapis.com/blogger/v3/blogs/3835840683626140337/pages"
      #     },
      #     "locale": {
      #         "language": "en",
      #         "country": "",
      #         "variant": ""
      #     }
      # }
    end

    def append_params_to_uri(base_uri, params)
      uri = URI.parse(base_uri)
      new_query_hash = Hash[URI.decode_www_form(uri.query || '')].merge(params)
      uri.query = URI.encode_www_form(new_query_hash)
      uri.to_s
    end

    def rest_call(url)
      response = Net::HTTP.get_response(URI.parse(url))
      return unless response.is_a?(Net::HTTPSuccess)

      resp_json = response.body
      JSON.parse(resp_json).with_indifferent_access
    end
  end
end
