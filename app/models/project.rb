require 'format'

class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :folder, :counter_cache => true, :touch => true
  has_many :critiques, :dependent => :destroy
  attr_accessible :title, :content, :user_id, :folder_id, :image

  validates_presence_of :title
  validates_presence_of :content

  has_attached_file :image

  acts_as_votable
  acts_as_voter

  def self.get_order_clause(order_by)
    case order_by
    when "alphabetical"
      "title"
    when "recentcreated"
      "created_at DESC"
    when "recentupdated"
      "updated_at DESC"
    when "lowcritiques"
      "critiques_count ASC"
    when "highcritiques"
      "critiques_count DESC"
    else
      ""
    end
  end

  def self.get_mentoring(order_by, user)
    Project.joins(:critiques).where("critiques.user_id = ?", user.id).uniq.order(order_by)
  end

  def self.get_recommended(order_by, user)
    @projects = Project.joins(:user).where("users.id <> ? AND (users.skill_level = ? OR users.skill_level = ?)", user.id, user.skill_level, user.lower_tier).order(order_by)
    @projects - self.get_mentoring(order_by, user)
  end

  def self.get_by_user(order_by, user)
    Project.where("user_id = ?", user.id).order(order_by)
  end

  def created_at_formatted
    self.created_at.strftime("%m-%d-%Y %I:%M%p")
  end

  def critique_options(limit = 5)
    Critique.joins(:project).where(["projects.user_id = ? AND critiques.created_at < ?", self.user.id, self.created_at]).order("critiques.created_at").limit(limit)
  end

  def is_mentored_by?(user) 
    @projects = Project.joins(:critiques).where("critiques.user_id = ?", user.id).uniq
    @projects.include? self
  end
end
