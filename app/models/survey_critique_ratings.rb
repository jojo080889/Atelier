class SurveyCritiqueRatings < ActiveRecord::Base
  attr_accessible :answer_text, :critique_id, :question_group_id, :user_id
end
