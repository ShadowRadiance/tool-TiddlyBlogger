# frozen_string_literal: true

module TiddlyBlogger
  class BlogConverter
    def convert(blog)
      blog.posts.map do |_post|
        'fake tiddler goes here'
      end
    end
  end
end
