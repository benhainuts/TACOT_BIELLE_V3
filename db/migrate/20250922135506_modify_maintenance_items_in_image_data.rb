class ModifyMaintenanceItemsInImageData < ActiveRecord::Migration[7.1]
  def change
    change_column :image_data, :maintenance_items, :text, array: true, default: [], using: "ARRAY[maintenance_items]"
  end
end
