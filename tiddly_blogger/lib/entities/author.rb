# frozen_string_literal: true

module TiddlyBlogger
  class Author
    def initialize(author_params)
      @author_id    = author_params[:id]
      @display_name = author_params[:displayName]
      @url          = author_params[:url]
      @image        = Image.new(author_params[:image])
    end
  end
end

#     "author": {
#         "id": string,
#         "displayName": string,
#         "url": string,
#         "image": {
#             "url": string
#         }
#     },
