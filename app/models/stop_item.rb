class StopItem < ApplicationRecord
  belongs_to :maintenance_item
  belongs_to :garage_stop
end
