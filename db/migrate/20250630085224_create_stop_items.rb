class CreateStopItems < ActiveRecord::Migration[7.1]
  def change
    create_table :stop_items do |t|
      t.references :maintenance_item, null: false, foreign_key: true
      t.references :garage_stop, null: false, foreign_key: true
      t.integer :price
      t.date :next_date_milestone
      t.integer :next_km_milestone

      t.timestamps
    end
  end
end
