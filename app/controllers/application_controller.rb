class ApplicationController < ActionController::API
  before_action :authenticate!

  def from_http
    request.headers["payload"]
  end

  def set_jot
    @token ||= JsonWebToken.decode(from_http)
    rescue JWT::VerificationError, JWT::DecodeError
      raise ActionController::RoutingError.new('Not Found')
  end

  def authenticate!
    if set_jot || @token[:id]
      @user ||= User.find_by(id: @token[:id])
      response.headers['Authorization'] = payload(@user) if @user
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def payload(user)
    puts(set_payload(user))
    encoded = JsonWebToken.encode(set_payload(user))
    puts(encoded)
    puts(JsonWebToken.decode(encoded))
    JsonWebToken.encode(set_payload(user))
  end

  def set_payload(user)
    {
      id: user.id,
      ride_count: user.ride_count,
      settings: {
        max_radius: user.setting.max_radius,
        min_radius: user.setting.min_radius,
        max_price: user.setting.max_price,
        min_price: user.setting.min_price,
        min_rating: user.setting.min_rating,
        max_rating: user.setting.max_rating
      }
    }.to_json
  end

end


