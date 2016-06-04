# frozen_string_literal: true

module TiddlyBlogger
  class Location
    attr_reader :name, :lat, :lng, :span

    def initialize(location_params)
      @name = location_params[:name]
      @lat = location_params[:lat]
      @lng = location_params[:lng]
      @span = location_params[:span]
    end
  end
end

#     "location": {
#         "name": string,
#         "lat": double,
#         "lng": double,
#         "span": string
#     },
