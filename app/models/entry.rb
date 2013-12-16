require 'format'

class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :critiques, :dependent => :destroy
  attr_accessible :title, :content, :user_id, :project_id, :image

  validates_presence_of :title
  validates_presence_of :content

  has_attached_file :image

  acts_as_votable
  acts_as_voter

  def created_at_formatted
    self.created_at.strftime("%m-%d-%Y %I:%M%p")
  end

  def critique_options(limit = 5)
    Critique.joins(:entry).where(["entries.user_id = ? AND critiques.created_at < ?", self.user.id, self.created_at]).order("critiques.created_at").limit(limit)
  end
end
