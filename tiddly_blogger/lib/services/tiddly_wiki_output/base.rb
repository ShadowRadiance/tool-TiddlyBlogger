# frozen_string_literal: true

require 'time'
require 'htmlentities'

module TiddlyWikiOutput
  class Base
    TIME_FORMAT = '%Y%m%d%H%M%S%L'

    def initialize
      @html_coder = HTMLEntities.new
    end

    def to_s
      div(tiddler_heading) do
        pre do
          tiddler_content
        end
      end
    end

    private

    def tag(tag_name, attrs = [])
      attr_string = attrs
                    .map { |k, v| %(#{k}="#{v}") }
                    .join(' ')
      <<~HTML
        <#{tag_name} #{attr_string}>
          #{yield}
        </#{tag_name}>
      HTML
    end

    %w[div pre blockquote cite].each do |tag_name|
      define_method tag_name do |attrs = [], &block|
        tag(tag_name, attrs, &block)
      end
    end

    def para(attrs = [], &block)
      tag('p', attrs, &block)
    end
  end
end
