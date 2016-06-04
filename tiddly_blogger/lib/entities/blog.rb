# frozen_string_literal: true

module TiddlyBlogger
  class Blog
    attr_accessor :blog_id, :name, :description, :url, :posts_count, :pages_count, :posts, :pages

    def initialize(blog_params)
      @blog_id = blog_params[:id]
      @name = blog_params[:name]
      @description = blog_params.fetch(:description, '')
      @url = blog_params.fetch(:url, '')
      @posts_count = blog_params[:posts][:totalItems]
      @pages_count = blog_params[:pages][:totalItems]

      @posts = Posts.new({})
      # self.pages = Pages.new([])
    end
  end
end

# {
#     "kind": "blogger#blog",
#     "id": "3835840683626140337",
#     "name": "ShadowRadiance",
#     "description": "",
#     "published": "2008-03-18T16:55:03-07:00",
#     "updated": "2014-10-04T20:01:34-07:00",
#     "url": "http://shadowradiance.blogspot.com/",
#     "selfLink": "https://www.googleapis.com/blogger/v3/blogs/3835840683626140337",
#     "posts": {
#         "totalItems": 1,
#         "selfLink": "https://www.googleapis.com/blogger/v3/blogs/3835840683626140337/posts"
#     },
#     "pages": {
#         "totalItems": 0,
#         "selfLink": "https://www.googleapis.com/blogger/v3/blogs/3835840683626140337/pages"
#     },
#     "locale": {
#         "language": "en",
#         "country": "",
#         "variant": ""
#     }
# }
