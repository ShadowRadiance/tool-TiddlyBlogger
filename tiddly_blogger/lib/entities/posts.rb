# frozen_string_literal: true

module TiddlyBlogger
  class Posts
    include Enumerable
    def initialize(posts_array)
      posts_array ||= []
      @posts = posts_array.map do |post_hash|
        Post.new(post_hash)
      end
    end

    def each(&block)
      @posts.each { |post| block.call(post) }
    end

    def length
      @posts.length
    end
    alias_method :size, :length
  end
end
