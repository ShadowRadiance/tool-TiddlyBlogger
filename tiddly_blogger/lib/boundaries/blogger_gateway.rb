# frozen_string_literal: true

require 'net/http'
require 'json'
require 'active_support/cache'
require 'active_support/core_ext/hash/indifferent_access'

module TiddlyBlogger
  class BloggerGateway
    BASE_URL = 'https://www.googleapis.com/blogger/v3/blogs'
    BLOG_BY_URL      = "#{BASE_URL}/byurl"
    POSTS_BY_BLOG_ID = "#{BASE_URL}/%{blog_id}/posts"
    COMMENTS_BY_POST_ID = "#{BASE_URL}/%{blog_id}/posts/%{post_id}/comments"

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
      posts = get_posts_by_blog_id_as_posts(blog.id)
      blog.posts = posts
      blog
    end

    def get_posts_by_blog_id(blog_id, page_token = nil)
      rest_call(url_for_posts_list(blog_id, page_token))
    end

    def get_comments_by_blog_id_and_post_id(blog_id, post_id, page_token = nil)
      rest_call(url_for_comments_list(blog_id, post_id, page_token))
    end

    def get_all_comments_by_blog_id_and_post_id(blog_id, post_id)
      items = []
      next_page_token = nil
      fetched = get_comments_by_blog_id_and_post_id(blog_id, post_id, next_page_token)
      while fetched[:items]&.length&.positive?
        items.concat(fetched[:items])
        next_page_token = fetched[:nextPageToken]
        break if next_page_token.nil?

        fetched = get_comments_by_blog_id_and_post_id(blog_id, post_id, next_page_token)
      end
      items
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def get_all_posts_by_blog_id(blog_id)
      items = []
      next_page_token = nil
      fetched = get_posts_by_blog_id(blog_id, next_page_token)
      while fetched[:items]&.length&.positive?
        fetched[:items].each do |item|
          item[:replies][:items] = if item[:replies][:totalItems].to_i.positive?
                                     get_all_comments_by_blog_id_and_post_id(blog_id, item[:id])
                                   else
                                     []
                                   end
        end
        items.concat(fetched[:items])
        next_page_token = fetched[:nextPageToken]
        break if next_page_token.nil?

        fetched = get_posts_by_blog_id(blog_id, next_page_token)
      end
      items
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def get_posts_by_blog_id_as_posts(blog_id)
      Posts.new(get_all_posts_by_blog_id(blog_id))
    end

    def url_for_comments_list(blog_id, post_id, page_token = nil)
      params = {
        key: @api_key,
        fields: 'nextPageToken,items(id,published,updated,content,author(displayName,image/url))'
      }
      params[:pageToken] = page_token if page_token
      append_params_to_uri(format(COMMENTS_BY_POST_ID, blog_id: blog_id, post_id: post_id), params)
    end

    # rubocop:disable Layout/LineLength
    def url_for_posts_list(blog_id, page_token = nil)
      params = {
        key: @api_key,
        fetchImages: true,
        fields: 'nextPageToken,items(id,blog/id,author(displayName,image/url),content,labels,images,published,updated,title,url,location,replies)'
      }
      params[:pageToken] = page_token if page_token
      append_params_to_uri(format(POSTS_BY_BLOG_ID, blog_id: blog_id), params)
    end
    # rubocop:enable Layout/LineLength

    def url_for_blog_by_url(blog_url)
      append_params_to_uri(BLOG_BY_URL, { url: blog_url, key: @api_key })
    end

    def append_params_to_uri(base_uri, params)
      uri = URI.parse(base_uri)
      new_query_hash = Hash[URI.decode_www_form(uri.query || '')].merge(params)
      uri.query = URI.encode_www_form(new_query_hash)
      uri.to_s
    end

    def rest_call(url)
      response = Net::HTTP.get_response(URI.parse(url))
      raise response.inspect unless response.is_a?(Net::HTTPSuccess)

      resp_json = response.body
      JSON.parse(resp_json).with_indifferent_access
    end
  end
end
