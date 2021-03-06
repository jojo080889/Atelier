class CritiqueRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :critique

  attr_accessible :user_id, :critique_id, :rating_id

  def critique_user
    self.critique.user
  end
end
