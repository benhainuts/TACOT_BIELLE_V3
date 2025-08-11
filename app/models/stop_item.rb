class StopItem < ApplicationRecord
  belongs_to :maintenance_item
  belongs_to :garage_stop

  has_many_attached :photos
end
