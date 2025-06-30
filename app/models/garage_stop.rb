class GarageStop < ApplicationRecord
  belongs_to :car_id
  belongs_to :garage_id
end
