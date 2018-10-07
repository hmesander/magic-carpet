require 'rails_helper'

RSpec.describe Api::V1::AdventuresController, type: :controller do
  before :each do
    restaurants = File.open("./fixtures/restaurant.json")
    estimate = File.open("./fixtures/lyft_estimate.json")
    reviews = File.open("./fixtures/reviews.json")
    stub_request(:get, "https://api.yelp.com/v3/businesses/search?latitude=39.7293&longitude=-104.9844&open_now=true&price=1,2,3&radius=3000&term=restaurants").
    with(
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>'Bearer CJO1wLSD-ZirOvL0ViX92AA4zmZdAdgEy8Gs0C-1UzgfmSt7NJ_QYrEjAx6ZA6SOUnNYpQgXK3MiuaOa-gfFkRWo00l0ehR0E_9uEmuSHXOQhEL0wT9t3H8nCvZPW3Yx',
        'User-Agent'=>'Faraday v0.12.2'
      }).
    to_return(status: 200, body: restaurants, headers: {})


    stub_request(:get, "https://api.yelp.com/v3/businesses/k1mGLPBSaUhZKem1KrXLJQ/reviews").
    with(
      headers: {
     'Accept'=>'*/*',
     'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     'Authorization'=>'Bearer CJO1wLSD-ZirOvL0ViX92AA4zmZdAdgEy8Gs0C-1UzgfmSt7NJ_QYrEjAx6ZA6SOUnNYpQgXK3MiuaOa-gfFkRWo00l0ehR0E_9uEmuSHXOQhEL0wT9t3H8nCvZPW3Yx',
     'User-Agent'=>'Faraday v0.12.2'
      }).
        to_return(status: 200, body: reviews, headers: {})

      stub_request(:get, "https://api.lyft.com/v1/cost?end_lat=39.7441431&end_lng=-104.9947764&ride_type=lyft&start_lat=39.7293&start_lng=-104.9844").
        with(
          headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Faraday v0.12.2'
          }).
          to_return(status: 200, body: estimate, headers: {})
  end

  describe 'create' do
    it 'should return the price and destination in json' do
         Setting.create(
           id: 0,
           max_radius: 4000,
           min_radius: 1000,
           min_rating: 0,
         )
      user = User.create!
      @request.headers["payload"] = JsonWebToken.encode({"id" => user.id}.to_json)
      parameters = {
        search_settings: {
          'open_now' => true,
          'radius' => 3000,
          'latitude' => 39.7293,
          'longitude' => -104.9844,
          'price' => "1,2,3",
          'term' => 'restaurants'
        },
        restrictions: {
            categories: [
              "italian",
              "indian"],
            min_radius: 1000
            }
        }
      post :create, body: parameters.to_json
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['price_range']['min_cost']).to eq(1052)
      expect(parsed_response['price_range']['max_cost']).to eq(1755)
      expect(parsed_response['destination']['name']).to eq("Prohibition")
      reviews = parsed_response['destination']['reviews']
      expect(reviews.count).to eq(3)
      expect(reviews.first).to have_content('id')
      expect(reviews.first).to have_content('text')
      expect(reviews.first).to have_content('rating')
      expect(reviews.first).to have_content('user')
    end
    it 'should return an error payload with status 400 if the filter params yeild no results' do
      Setting.create(
        id: 0,
        max_radius: 4000,
        min_radius: 1000,
        min_rating: 0,
          )
      user = User.create!
      @request.headers["payload"] = JsonWebToken.encode({"id" => user.id}.to_json)
      parameters = {
        search_settings: {
          'open_now' => true,
          'radius' => 3000,
          'latitude' => 39.7293,
          'longitude' => -104.9844,
          'price' => "1,2,3",
          'term' => 'restaurants'
        },
        restrictions: {
            categories: [
              "italian",
              "indian"],
            min_radius: 5000
            }
        }
      post :create, body: parameters.to_json
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['message']).to eq("An error has occurred.")
      expect(parsed_response['error']).to eq("ImpossibleRequest: Filter Criteria too strict")
      expect(response.status).to eq(400)
    end
  end
end
