# frozen_string_literal: true

require_relative "base"

module TiddlyWikiOutput
  class SiteTitle < Base
    def tiddler_heading
      {
        created: now.strftime(TIME_FORMAT),
        modified: now.strftime(TIME_FORMAT),
        title: "$:/SiteTitle"
      }
    end

    def tiddler_content
      "Exported Google Blogger"
    end

    private

    def now
      @now ||= Time.now.utc
    end
  end
end
