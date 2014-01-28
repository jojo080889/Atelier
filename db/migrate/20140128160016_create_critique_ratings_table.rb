class CreateCritiqueRatingsTable < ActiveRecord::Migration
  def change
    create_table :critique_ratings do |t|
      t.integer :user_id
      t.integer :critiques_id
      t.integer :rating_id
    end
  end
end
