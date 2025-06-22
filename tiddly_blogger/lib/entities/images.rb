# frozen_string_literal: true

module TiddlyBlogger
  class Images
    include Enumerable
    def initialize(images_array)
      images_array ||= []
      @images = images_array.map do |image_params|
        Image.new(image_params)
      end
    end

    def each(&block)
      @images.each { |image| block.call(image) }
    end

    def length
      @images.length
    end
    alias_method :size, :length
  end
end
