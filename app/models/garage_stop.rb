class GarageStop < ApplicationRecord
  belongs_to :car
  belongs_to :garage
  has_many :stop_items
end
