# frozen_string_literal: true

module TiddlyBlogger
  class Author
    attr_reader :author_id, :display_name, :image

    def initialize(author_params)
      @display_name = author_params[:displayName]
      @image        = Image.new(author_params[:image])
    end
  end
end

#     "author": {
#         "displayName": string,
#         "image": {
#             "url": string
#         }
#     },
