class DestinationHandler
  def initialize(parameters)
    @parameters   = parameters
    @settings     = HashWithIndifferentAccess.new(parameters[:search_settings])
    @restrictions = HashWithIndifferentAccess.new(parameters[:restrictions])
    # should be:
    # {
      # search_settings: {
        # radius: int(in meters),
        # latitude: decimal,
        # longitude: decimal,
        # price: [int,int,int],
        # term: 'restaurants',
        # open_now: true
      # }
      # restrictions: {
      #   categories : [
      #     "italian",
      #     "indian"
      #   ]
      #   min_radius: 1000
      #   }
      # }
  end

  def get_reviews(dest)
    YelpSearcher.new.get_reviews(dest)
  end

  def record_adventure(destination)
    setting = Setting.create!(
      max_radius: @settings[:radius],
      min_radius: @restrictions[:min_radius],
      price: @settings[:price]
      )
    Adventure.create(
      start_lat: @settings[:latitude],
      start_long: @settings[:longitude],
      destination: destination.name,
      setting: setting)
  end

  def find_a_restaurant
    destination = WeightedRandomizer.new.decide(get_restaurants)
    destination.reviews = get_reviews(destination)
    record_adventure(destination)
    destination
    # WeightedRandomizer is a module which will return a single object picked out of a given array
    # as long as that object responds to rating
  end

  def get_restaurants
    restaurants = YelpSearcher.new(parameters[:search_settings]).get_restaurants
    Filter.remove(parameters[:restrictions],
      restaurants)
    # This is the area which would act as a router between our different destination information retrival methods and locations
  end

  private

  attr_reader :parameters
end