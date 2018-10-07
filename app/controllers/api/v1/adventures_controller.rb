class Api::V1::AdventuresController < ApplicationController
  def create
    safe_query do
      dest = DestinationHandler.new(preferences).find_a_restaurant
      l_s = LyftService.new(@user)
      puts("sending them to #{dest.name}")
      render json: {
        price_range: l_s.get_estimate(current_location, dest.location),
        destination: dest
      }
    end
  end
end