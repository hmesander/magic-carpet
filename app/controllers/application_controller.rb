class ApplicationController < ActionController::API
  # before_action :authenticate!

  def from_http
    request.headers["payload"]
  end

  def preferences
    JSON.parse(request.body.string, symbolize_names: true)
  end

  def set_jot
    begin
      @token ||= JsonWebToken.decode(from_http)
    rescue JWT::VerificationError, JWT::DecodeError
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def authenticate!
    if set_jot || @token[:id]
      @user ||= User.find_by(id: @token[:id])
      @user.api_token=(@token[:token])
      @user.refresh_token=(@token[:refresh_token])
      response.headers['Authorization'] = payload(@user) if @user
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def current_location
    {
      latitude: preferences[:search_settings][:latitude],
      longitude: preferences[:search_settings][:longitude]
    }
  end

  def safe_query
    begin
      yield
    rescue => err
      render json: {
        message: "An error has occurred.",
        error: "#{err.class}: #{err}"
      }, status: 400
    end
  end

end
