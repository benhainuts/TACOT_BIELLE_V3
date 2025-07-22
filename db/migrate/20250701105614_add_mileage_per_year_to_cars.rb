class AddMileagePerYearToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :mileage_per_year, :integer
  end
end
