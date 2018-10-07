require './app/services/destination'
class YelpSearcher
  def initialize(parameters = {})
    @parameters = parameters
  end

  def get_restaurants
    get_restaurants_json[:businesses].map do |restaurant_json|
      Destination.new(restaurant_json)
    end
  end

  def get_restaurants_json
    JSON.parse(search_businesses.body, symbolize_names: true)
  end

  def get_reviews(destination)
    response = conn.get("businesses/#{destination.id}/reviews")
    reviews = JSON.parse(response.body, symbolize_names: true)[:reviews]
    reviews.each do |rev|
      rev[:text].gsub!(destination.name, '?'*destination.name.length)
    end
  end

  def search_businesses
    conn.get("businesses/search") do |req|
      parameters.each do |search, value|
        req.params[search] = value
      end
    end
  end

  def conn
    Faraday.new(:url => "https://api.yelp.com/v3/") do |faraday|
      faraday.headers[:Authorization] = ("Bearer " + ENV["yelp_api_key"])
      faraday.adapter Faraday.default_adapter
    end
  end

  private 
  attr_reader :parameters

end