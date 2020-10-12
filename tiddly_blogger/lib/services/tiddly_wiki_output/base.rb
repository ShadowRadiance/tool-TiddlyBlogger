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

    def div(attrs)
      attr_string = attrs
                    .map { |k, v| %(#{k}="#{v}") }
                    .join(' ')

      <<~HTML
        <div #{attr_string}>
          #{yield}
        </div>
      HTML
    end

    def pre
      "<pre>#{yield}</pre>"
    end
  end
end
