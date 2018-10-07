class Setting < ApplicationRecord
  has_many :adventures
  def price
    (min_price..max_price).to_a
  end
end
