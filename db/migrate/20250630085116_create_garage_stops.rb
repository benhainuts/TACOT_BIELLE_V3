class CreateGarageStops < ActiveRecord::Migration[7.1]
  def change
    create_table :garage_stops do |t|
      t.date :date
      t.integer :mileage
      t.references :car, null: false, foreign_key: true
      t.references :garage, null: false, foreign_key: true
      t.integer :cost
      t.text :comments

      t.timestamps
    end
  end
end
