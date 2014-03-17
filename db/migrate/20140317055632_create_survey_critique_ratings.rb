class CreateSurveyCritiqueRatings < ActiveRecord::Migration
  def change
    create_table :survey_critique_ratings do |t|
      t.integer :user_id
      t.integer :question_group_id
      t.integer :critique_id
      t.string :answer_text

      t.timestamps
    end
  end
end
