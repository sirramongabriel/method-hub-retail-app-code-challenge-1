class Product < ApplicationRecord
  validates :price_in_cents, numericality: { less_than_or_equal_to: 1000000 }, message: "Product price cannot exceed $10,0000"
end
