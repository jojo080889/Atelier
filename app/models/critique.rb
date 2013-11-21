class Critique < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :mentor_id, :project_id, :url
end
