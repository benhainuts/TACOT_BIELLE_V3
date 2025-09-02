class CreateImageData < ActiveRecord::Migration[7.1]
  def change
    create_table :image_data do |t|
      t.references :user, null: false, foreign_key: true
      t.string :invoice_number
      t.string :number_plate
      t.string :make
      t.string :model
      t.integer :mileage
      t.string :energy
      t.text :maintenance_items

      t.timestamps
    end
  end
end
