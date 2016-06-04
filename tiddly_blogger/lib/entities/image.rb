# frozen_string_literal: true

module TiddlyBlogger
  class Image
    attr_reader :original_url

    def initialize(image_params)
      @original_url = image_params[:url]
    end
  end
end

# { "url": string },
