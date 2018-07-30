class Destination
  
  attr_reader :name,
              :rating,
              :categories,
              :latitude,
              :longitude,
              :street_address,
              :city,
              :state,
              :zip_code,
              :distance,
              :categories

  def initialize(information)
    @name = information[:name]
    @price = information[:price]
    @rating = information[:rating]
    @categories = set_categories(information[:categories])
    @latitude = information[:coordinates][:latitude]
    @longitude = information[:coordinates][:longitude]
    @street_address = information[:location][:display_address][0]
    @city = information[:location][:city]
    @state = information[:location][:state]
    @zip_code = information[:location][:zip_code]
    @distance = information[:distance]
  end

  def set_categories(rest_categories)
    rest_categories.map do |category|
      category[:alias]
    end
  end


  def location
    {
      latitude: latitude,
      longitude: longitude
    }
  end
end