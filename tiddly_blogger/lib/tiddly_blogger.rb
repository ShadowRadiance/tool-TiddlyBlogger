# frozen_string_literal: true

require "tiddly_blogger/version"

module TiddlyBlogger
  # Entities should not need anything except other entities
  require "entities/errors"

  require "entities/image"
  require "entities/images"
  require "entities/author"
  require "entities/comment"
  require "entities/comments"
  require "entities/location"
  require "entities/post"
  require "entities/posts"
  require "entities/blog"

  # services should only need to know about entities
  require "services/blog_converter"

  # Requests and responses should be simple structs with no dependencies
  require "requests/blog_conversion_request"
  require "responses/blog_conversion_response"

  # boundaries might need to know about requests and responses
  require "boundaries/blogger_gateway"

  # Interactors might require just about anything
  require "interactors/convert_blog"
end
