class Project < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title, :url, :user_id
end
