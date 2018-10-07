class LyftService

  def initialize(user)
    @user = user
  end

  def get_estimate(origin, destination)
    response = get_cost(origin, destination)
    body = JSON.parse(response.body)["cost_estimates"].first

    min_price = body['estimated_cost_cents_min']
    max_price = body['estimated_cost_cents_max']
    cost_token = body['cost_token']
    { "min_cost": min_price, "max_cost": max_price, "cost_token": cost_token}
  end

  private
  def conn
    Faraday.new(url: 'https://api.lyft.com') do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end

  def get_cost(origin, destination)
    conn.get('/v1/cost') do |request|
      request.headers['Content-Type'] = 'application/json'
      request.params = {
        start_lat: origin[:latitude],
        start_lng: origin[:longitude],
        end_lat: destination[:latitude],
        end_lng: destination[:longitude],
        ride_type: 'lyft'
      }
    end
  end
end
