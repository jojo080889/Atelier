class User < ActiveRecord::Base
  has_many :projects
  has_many :critiques

  acts_as_voter

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :skill_level, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  def can_critique(project)
    self.id != project.user.id && (self.skill_level == project.user.skill_level || self.lower_tier == project.user.skill_level)
  end

  def lower_tier
    case self.skill_level
    when "Beginner"
      "Beginner"
    when "Intermediate"
      "Beginner"
    when "Advanced"
      "Intermediate"
    else
      "Beginner"
    end
  end

  def critiques_received
    Critique.joins(:project).where("projects.user_id = ?", self.id)
  end

  def projects_likes
    likes = []
    self.projects.each do |p|
      likes = likes + p.likes
    end
    likes
  end

  def critiques_likes
    likes = []
    self.critiques.each do |c|
      likes = likes + c.likes
    end
    likes
  end
end
