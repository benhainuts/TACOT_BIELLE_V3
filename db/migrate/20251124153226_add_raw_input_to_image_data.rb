class AddRawInputToImageData < ActiveRecord::Migration[7.1]
  def change
    add_column :image_data, :raw_input, :text
  end
end
