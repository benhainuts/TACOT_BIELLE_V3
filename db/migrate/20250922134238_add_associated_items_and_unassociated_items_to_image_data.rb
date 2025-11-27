class AddAssociatedItemsAndUnassociatedItemsToImageData < ActiveRecord::Migration[7.1]
  def change
    add_column :image_data, :associated_items, :text, array:true, default: []
    add_column :image_data, :unassociated_items, :text, array:true, default: []
  end
end
