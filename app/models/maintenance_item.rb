class MaintenanceItem < ApplicationRecord
  belongs_to :car
  has_many :stop_items
end
