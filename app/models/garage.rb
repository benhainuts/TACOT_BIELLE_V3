class Garage < ApplicationRecord
  has_many :garage_stops
  has_many :cars, through: :garage_stops
  has_many :stop_items, through: :garage_stops
end
