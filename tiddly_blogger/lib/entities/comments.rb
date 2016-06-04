# frozen_string_literal: true

module TiddlyBlogger
  class Comments
    include Enumerable
    def initialize(comments_params)
      comments_params ||= []
      @comments = comments_params.map do |comment_params|
        Comment.new(comment_params)
      end
    end

    def each(&block)
      @comments.each { |comment| block.call(comment) }
    end

    def length
      @comments.length
    end
    alias size length
  end
end
