class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.string :number_plate
      t.date :first_registration_date
      t.string :make
      t.string :model
      t.string :energy
      t.integer :horsepower
      t.integer :mileage
      t.date :last_technical_control_date
      t.date :last_maintenance_operation_made_on
      t.string :last_maintenance_operation_mileage
      t.date :created_on
      t.date :modified_on
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
