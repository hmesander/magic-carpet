class Filter 
  def self.remove(parameters, restaurants)
    remaining = filter_out(parameters, restaurants)
    !remaining.empty? ? remaining : raise(ImpossibleRequest.new('Filter Criteria too strict', 400))
  end

  def self.check_distance(distance, restaurant)
    restaurant.distance.to_i <= distance.to_i
  end

  def self.check_categories(categories, restaurant)
    !(restaurant.categories & categories).empty?
  end

  def self.filter_out(parameters, restaurants)
    restaurants.reject do |restaurant|
      check_distance(parameters[:min_radius], restaurant) ||
      check_categories(parameters[:categories], restaurant)
    end
  end
end
