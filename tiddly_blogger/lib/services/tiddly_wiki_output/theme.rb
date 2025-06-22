# frozen_string_literal: true

require_relative "base"

module TiddlyWikiOutput
  class Theme < Base
    def tiddler_heading
      {
        created: now.strftime(TIME_FORMAT),
        modified: now.strftime(TIME_FORMAT),
        title: "$:/theme"
      }
    end

    def tiddler_content
      "$:/themes/tiddlywiki/snowwhite"
    end

    private

    def now
      @now ||= Time.now.utc
    end
  end
end
