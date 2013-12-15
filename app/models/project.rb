require 'format'

class Project < ActiveRecord::Base
  belongs_to :user
  has_many :entries, :dependent => :destroy
  attr_accessible :name, :description, :user_id

  def is_mentored_by?(user) 
    @projects = Project.joins(:entries => :critiques).where("critiques.user_id = ?", user.id).uniq
    @projects.include? self
  end
end
