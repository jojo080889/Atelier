class AddRatingToCritique < ActiveRecord::Migration
  def change
    add_column :critiques, :rating, :integer
  end
end
