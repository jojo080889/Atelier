class Response < ActiveRecord::Base
  belongs_to :critique
  belongs_to :user
  
  validates :guest_name, presence: true, if: "user.is_guest?"
  validates :text, presence: true

  attr_accessible :critique_id, :text, :user_id, :guest_name
end
