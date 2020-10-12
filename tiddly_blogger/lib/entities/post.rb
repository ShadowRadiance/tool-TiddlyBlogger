# frozen_string_literal: true

module TiddlyBlogger
  class Post
    attr_reader :id, :blog_id, :published, :updated, :url, :title,
                :content, :images, :author, :comments, :labels, :location

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def initialize(post_params)
      @id        = post_params[:id]
      @blog_id   = post_params[:blog][:id]
      @published = post_params[:published]
      @updated   = post_params[:updated]
      @url       = post_params[:url]
      @title     = post_params[:title]
      @content   = post_params[:content]
      @images    = Images.new(post_params[:images])
      @author    = Author.new(post_params[:author])
      @comments  = Comments.new(post_params.dig(:replies, :items))
      @labels    = post_params[:labels] || []
      @location  = post_params[:location] && Location.new(post_params[:location])
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
  end
end
