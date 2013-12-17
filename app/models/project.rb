require 'format'

class Project < ActiveRecord::Base
  belongs_to :user
  has_many :entries, :dependent => :destroy
  has_many :critiques, through: :entries
  attr_accessible :name, :description, :user_id

  validates_presence_of :name
  validates_presence_of :description

  def self.get_order_clause(order_by)
    case order_by
    when "alphabetical"
      "name"
    when "recentcreated"
      "created_at DESC"
    when "recentupdated"
      "updated_at DESC"
    when "lowentries"
      "entries_count ASC"
    when "highentries"
      "entries_count DESC"
    when "lowcritiques"
      "critiques_count ASC"
    when "highcritiques"
      "critiques_count DESC"
    else
      ""
    end
  end

  def self.get_all(order_by)
    Project.order(order_by) 
  end

  def self.get_mentoring(order_by, user)
    Project.joins(:entries => :critiques).where("critiques.user_id = ?", user.id).uniq.order(order_by)
  end

  def self.get_recommended(order_by, user)
    @projects = Project.joins(:user).where("users.id <> ? AND (users.skill_level = ? OR users.skill_level = ?)", user.id, user.skill_level, user.lower_tier).order(order_by)
    @projects - self.get_mentoring(order_by, user)
  end

  def self.get_mine(order_by, user)
    Project.joins(:user).joins(:entries => :critiques).where("users.id = ?", user.id).order(order_by)
  end

  def is_mentored_by?(user) 
    @projects = Project.joins(:entries => :critiques).where("critiques.user_id = ?", user.id).uniq
    @projects.include? self
  end
end
