class AddUseToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :use, :string
  end
end
