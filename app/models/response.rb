class Response < ActiveRecord::Base
  belongs_to :critique
  belongs_to :user

  attr_accessible :critique_id, :text, :user_id
end
