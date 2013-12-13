class User < ActiveRecord::Base
  has_many :projects
  has_many :entries
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
  
  def can_critique?(entry)
    self.id != entry.user.id && (self.skill_level == entry.user.skill_level || self.lower_tier == entry.user.skill_level)
  end

  def next_tier
    case self.skill_level
    when "Beginner"
      "Intermediate"
    when "Intermediate"
      "Advanced"
    when "Advanced"
      "Advanced"
    end
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

  def next_tier_ratings
    case self.skill_level
    when "Beginner"
      Critique.joins(:entry).where("entries.user_id = ? AND rating = 3", self.id).count
    when "Intermediate"
      Critique.joins(:entry).where("entries.user_id = ? AND rating = 5", self.id).count
    else
      0
    end
  end

  def critiques_received
    Critique.joins(:entry).where("entries.user_id = ?", self.id)
  end

  def critiques_likes
    likes = []
    self.critiques.each do |c|
      likes = likes + c.likes
    end
    likes
  end

  def recent_critiques_received(limit = 5)
    Critique.where(:user_id => self.id).order(:created_at).limit(limit)
  end

  def num_helpful_critiques_needed
    10 - self.critiques_likes.count
  end
end
