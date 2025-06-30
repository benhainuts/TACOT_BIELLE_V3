class Car < ApplicationRecord
  belongs_to :user
  belogns_to

  validates :number_plate, presence: true, uniqueness: true

  has_many :garage_stops
  has_many :maintenance_items
end
