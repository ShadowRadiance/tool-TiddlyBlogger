# frozen_string_literal: true

module TiddlyBlogger
  class Comment
    def initialize(comment_params)
      @id = comment_params[:id]
      @published = comment_params[:published]
      @updated = comment_params[:updated]
      @content = comment_params[:content]
      @author = Author.new(comment_params[:author])
    end
  end
end

# {
#   "id": string,
#   "published": datetime,
#   "updated": datetime,
#   "content": string,
#   "author": {
#     "displayName": string,
#     "image": {
#       "url": string
#     }
#   }
# }
