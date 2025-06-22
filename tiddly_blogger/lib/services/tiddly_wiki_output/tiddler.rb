# frozen_string_literal: true

require "time"
require "htmlentities"
require_relative "base"

module TiddlyWikiOutput
  class TiddlerHtml < Base
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
      [
        tiddlerize_content(@post.content),
        comments
      ].compact.join("\n")
    end

    private

    def comments
      @comments ||= @post.comments.map(&method(:tiddlerize_comment))
    end

    def tiddlerize_content(content)
      content
    end

    def tiddlerize_comment(comment)
      blockquote(class: "tc-quote tc-big-quote") do
        [
          para { comment.content },
          cite { "#{comment.author.display_name} (#{Time.xmlschema(comment.published)})" }
        ].join
      end
    end

    def author
      @post.author&.display_name || "Anonymous"
    end

    def type
      "text/html"
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
          .join(" ")
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

  class Tiddler < TiddlerHtml
    def tiddler_heading
      {
        author: author,
        created: created,
        modified: modified,
        tags: tags,
        title: title
      }
    end

    def tiddlerize_content(content)
      super
      # TODO: convert html content from google into tiddlywiki format
    end

    def tiddlerize_comment(comment)
      <<~WIKITEXT
        \n
        <<<.tc-big-quote
        #{comment.content}
        <<< #{comment.author.display_name} (#{Time.xmlschema(comment.published)})
      WIKITEXT
    end
  end
end
