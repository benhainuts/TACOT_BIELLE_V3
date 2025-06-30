class StopItem < ApplicationRecord
  belongs_to :maintenance_item_id
  belongs_to :garage_stop_id
end
