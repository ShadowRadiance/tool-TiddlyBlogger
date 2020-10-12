# frozen_string_literal: true

require 'time'
require 'htmlentities'
require_relative 'base'

module TiddlyWikiOutput
  class Tiddler < Base
    def initialize(post)
      super()
      @post = post
    end

    def tiddler_heading
      {
        author: author,
        created: created,
        modified: modified,
        tags: tags,
        title: title,
        type: type
      }
    end

    def tiddler_content
      @post.content
    end

    private

    def author
      @post.author&.display_name || 'Anonymous'
    end

    def type
      'text/html'
    end

    def created
      dates.min.strftime(TIME_FORMAT)
    end

    def modified
      dates.max.strftime(TIME_FORMAT)
    end

    def tags
      @html_coder.encode(
        @post.labels
          .map { |label| "[[#{label}]]" }
          .join(' ')
          .to_s
      )
    end

    def title
      @html_coder.encode(@post.title)
    end

    def dates
      @dates ||= [
        Time.xmlschema(@post.updated).utc,
        Time.xmlschema(@post.published).utc
      ]
    end
  end
end
