class Car < ApplicationRecord
  belongs_to :user

  # validates :number_plate, presence: true, uniqueness: true
  # validates :model, presence: true
  # validates :make, presence: true
  # validates :mileage, presence: true
  # validates :first_registration_date, presence: true
  # validates :energy, presence: true
  # validates :horsepower, presence: true

  # validates , presence: true
  # validates :model, presence: true

  has_many :garage_stops
  has_many :maintenance_items
end
