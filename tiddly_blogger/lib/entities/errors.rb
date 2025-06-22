# frozen_string_literal: true

module TiddlyBlogger
  class Errors
    include Enumerable
    def initialize(errors)
      @errors = errors || []
    end

    def each(&block)
      @errors.each { |error| block.call(error) }
    end

    def length
      @errors.length
    end
    alias_method :size, :length
  end
end
