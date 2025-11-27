class AddPriceAndDateToImageData < ActiveRecord::Migration[7.1]
  def change
    add_column :image_data, :price, :decimal
    add_column :image_data, :date, :date
  end
end
