require 'rails_helper'

describe 'Lyft Service' do
  describe '#get_estimate' do
    it 'returns an cost min and cost max for ride' do
      user = User.create
      origin = { latitude: 37.77663, longitude: -122.39227 }
      destination = { latitude: 37.771, longitude: -122.39123 }

      stub_request(:get, "https://api.lyft.com/v1/cost?end_lat=37.771&end_lng=-122.39123&ride_type=lyft&start_lat=37.77663&start_lng=-122.39227").
          with(
            headers: {
                     'Accept'=>'*/*',
                     'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                     'Content-Type'=>'application/json',
                     'User-Agent'=>'Faraday v0.12.2'
                      }).
                    to_return(status: 200,
                              body: '{
                                "cost_estimates": [
                                  {
                                      "currency": "USD",
                                      "ride_type": "lyft",
                                      "display_name": "Lyft",
                                      "primetime_percentage": "25%",
                                      "primetime_confirmation_token": null,
                                      "cost_token": null,
                                      "price_quote_id": "17f87a53f3917dcc0cfc2a74b7bf267e9b97d37539a1f9b2310a81f00bc09ca4",
                                      "is_valid_estimate": true,
                                      "estimated_duration_seconds": 1626,
                                      "estimated_distance_miles": 5.52,
                                      "estimated_cost_cents_min": 1052,
                                      "estimated_cost_cents_max": 1755,
                                      "can_request_ride": true
                                  }
                                ]
                              }',
                              headers: {}
                             )

      lyft_service = LyftService.new(user)
      actual = lyft_service.get_estimate(origin, destination)

      expect(actual[:min_cost]).to eq(1052)
      expect(actual[:max_cost]).to eq(1755)
    end
  end
end
