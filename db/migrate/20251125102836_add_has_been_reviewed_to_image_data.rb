class AddHasBeenReviewedToImageData < ActiveRecord::Migration[7.1]
  def change
    add_column :image_data, :has_been_reviewed, :boolean, default: false
  end
end
