class RenameCritiqueColumnInCritiqueRatings < ActiveRecord::Migration
  def change
    rename_column :critique_ratings, :critiques_id, :critique_id
  end
end
