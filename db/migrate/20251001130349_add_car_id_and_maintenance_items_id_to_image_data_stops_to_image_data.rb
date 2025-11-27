class AddCarIdAndMaintenanceItemsIdToImageDataStopsToImageData < ActiveRecord::Migration[7.1]
  def change
    add_reference :image_data, :car, foreign_key: true
    add_reference :image_data, :garage_stop, foreign_key: true
  end
end
