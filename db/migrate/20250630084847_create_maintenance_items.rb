class CreateMaintenanceItems < ActiveRecord::Migration[7.1]
  def change
    create_table :maintenance_items do |t|
      t.references :car, null: false, foreign_key: true
      t.string :item_name
      t.integer :to_do_every_x_km
      t.integer :to_do_every_x_years
      t.boolean :one_shot_operation

      t.timestamps
    end
  end
end
