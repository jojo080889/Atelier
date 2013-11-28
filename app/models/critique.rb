class Critique < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :responses
  attr_accessible :user_id, :project_id, :text, :rating

  acts_as_votable
end
