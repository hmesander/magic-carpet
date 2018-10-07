require 'rails_helper'
describe 'Filter' do
  describe '.remove' do
    it 'should remove all obejcts which dont fit with the specified parameters' do
      parameters ={
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

      restaurants = File.open("./fixtures/restaurants.json")

      stub_request(:get, "https://api.yelp.com/v3/businesses/search?latitude=39.7293&longitude=-104.9844&open_now=true&price=1,2,3&radius=3000&term=restaurants").
      with(
        headers: {
       'Accept'=>'*/*',
       'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'Authorization'=>"Bearer #{ENV['yelp_api_key']}",
       'User-Agent'=>'Faraday v0.12.2'
        }).
         to_return(status: 200, body: restaurants, headers: {})
      dh = DestinationHandler.new(parameters)
      rests = dh.get_restaurants
      results = Filter.remove(parameters[:restrictions], rests)
      results.each do |result|
        expect(result.distance).to be > parameters[:restrictions][:min_radius].to_i
        expect(result.categories).to_not include(parameters[:restrictions][:categories].first)
      end
    end

    it 'should return an error if the filtered parameters are impossible' do
      parameters ={
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
            min_radius: 4000
          }
        }

      restaurants = File.open("./fixtures/restaurants.json")

      stub_request(:get, "https://api.yelp.com/v3/businesses/search?latitude=39.7293&longitude=-104.9844&open_now=true&price=1,2,3&radius=3000&term=restaurants").
      with(
        headers: {
       'Accept'=>'*/*',
       'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'Authorization'=>"Bearer #{ENV['yelp_api_key']}",
       'User-Agent'=>'Faraday v0.12.2'
        }).
         to_return(status: 200, body: restaurants, headers: {})
      dh = DestinationHandler.new(parameters)
      expect{rests = dh.get_restaurants}.to raise_error(ImpossibleRequest)
    end
    
    it 'should return the reviews but with the name of the destination redacted' do
      parameters ={
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

      restaurants = File.open("./fixtures/restaurant.json")
      reviews = File.open("./fixtures/reviews.json")

      stub_request(:get, "https://api.yelp.com/v3/businesses/k1mGLPBSaUhZKem1KrXLJQ/reviews").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer CJO1wLSD-ZirOvL0ViX92AA4zmZdAdgEy8Gs0C-1UzgfmSt7NJ_QYrEjAx6ZA6SOUnNYpQgXK3MiuaOa-gfFkRWo00l0ehR0E_9uEmuSHXOQhEL0wT9t3H8nCvZPW3Yx',
          'User-Agent'=>'Faraday v0.12.2'
           }).
      to_return(status: 200, body: reviews, headers: {})

      stub_request(:get, "https://api.yelp.com/v3/businesses/search?latitude=39.7293&longitude=-104.9844&open_now=true&price=1,2,3&radius=3000&term=restaurants").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>"Bearer #{ENV['yelp_api_key']}",
          'User-Agent'=>'Faraday v0.12.2'
        }).
      to_return(status: 200, body: restaurants, headers: {})

      dh = DestinationHandler.new(parameters)
      restaurant = dh.find_a_restaurant
      reviews = restaurant.reviews.map {|review|review[:text]}
      expect(reviews.any?{|review|review.include?(restaurant.name)}).to eq(false)
    end
  end
end
