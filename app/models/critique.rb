class Critique < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry
  has_many :responses
  attr_accessible :user_id, :entry_id, :text, :rating

  acts_as_votable
end
