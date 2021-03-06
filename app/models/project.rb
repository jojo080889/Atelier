require 'format'

class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :folder, :counter_cache => true, :touch => true
  has_many :critiques, :dependent => :destroy
  attr_accessible :title, :content, :user_id, :folder_id, :image, :doneness, :tag_list

  validates_presence_of :title

  has_attached_file :image
  validates_attachment_content_type :image, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'Your attachment is the wrong file type. Only jpeg/jpg/png/gif images are allowed.'
  validates_attachment_presence :image

  acts_as_taggable
  is_impressionable

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
    @projects = Project.joins(:user).where("users.id <> ? AND (users.skill_level_id = ? OR users.skill_level_id = ?)", user.id, user.skill_level.id, user.skill_level.lower_tier.id).order(order_by)
    @projects - self.get_mentoring(order_by, user)
  end

  def self.get_by_user(order_by, user)
    Project.where("user_id = ?", user.id).order(order_by)
  end

  # Gets the project after this one in the list of recommended projects for the
  # current user. Returns nil if it reaches the end of the list.
  def recommended_next(user)
    if Atelier::Application.config.skill_levels
      @recommended = Project.get_recommended(Project.get_order_clause("lowcritiques"), user)
    else
      @recommended = Project.order(Project.get_order_clause("lowcritiques"))
    end
    index = @recommended.index(self)
    @recommended[index + 1]
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
