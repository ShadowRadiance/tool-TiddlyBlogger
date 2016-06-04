# frozen_string_literal: true

module TiddlyBlogger
  class BlogConversionError
    attr_reader :error_description

    def initialize(error_description:)
      @error_description = error_description
    end
  end
end
