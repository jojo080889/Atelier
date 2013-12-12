require 'format'

class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :critiques
  attr_accessible :title, :content, :user_id, :project_id

  acts_as_votable

  def created_at_formatted
    self.created_at.strftime("%m-%d-%Y %I:%M%p")
  end
end
