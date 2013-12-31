require 'format'

class Folder < ActiveRecord::Base
  belongs_to :user
  has_many :projects, :dependent => :destroy
  has_many :critiques, through: :projects
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
    when "lowprojects"
      "projects_count ASC"
    when "highprojects"
      "projects_count DESC"
    when "lowcritiques"
      "critiques_count ASC"
    when "highcritiques"
      "critiques_count DESC"
    else
      ""
    end
  end

  def self.get_all(order_by)
    Folder.order(order_by) 
  end

  def self.get_mentoring(order_by, user)
    Folder.joins(:projects => :critiques).where("critiques.user_id = ?", user.id).uniq.order(order_by)
  end

  def self.get_recommended(order_by, user)
    @folders = Folder.joins(:user).where("users.id <> ? AND (users.skill_level = ? OR users.skill_level = ?)", user.id, user.skill_level.id, user.skill_level.lower_tier.id).order(order_by)
    @folders - self.get_mentoring(order_by, user)
  end

  def self.get_by_user(order_by, user)
    Folder.joins(:user).where("users.id = ?", user.id).order(order_by)
  end

  def is_mentored_by?(user) 
    @folders = Folder.joins(:projects => :critiques).where("critiques.user_id = ?", user.id).uniq
    @folders.include? self
  end
end
