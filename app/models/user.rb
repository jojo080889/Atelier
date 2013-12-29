class User < ActiveRecord::Base
  has_many :folders
  has_many :projects
  has_many :critiques

  acts_as_voter

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true
  validates_presence_of :birthday, :on => :create
  validate :birthday_older_than_13

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :skill_level, :email, :password, :password_confirmation, :birthday, :remember_me
  
  def to_param
    username
  end

  # A custom validation to check that all users are 13 or older
  def birthday_older_than_13
    now = Time.now.utc.to_date
    if !birthday.nil? 
      age = now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
    end
    errors.add(:birthday, "must show that you are 13 or older.") if birthday.nil? || age < 13
  end

  # Users can critique if they are a guest or if they are a logged in user with the right
  # skill level.
  def can_critique?(project)
    (self.is_guest? || (self.id != project.user.id && (self.skill_level == project.user.skill_level || self.lower_tier == project.user.skill_level)))
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
      Critique.joins(:project).where("projects.user_id = ? AND rating = 3", self.id).count
    when "Intermediate"
      Critique.joins(:project).where("projects.user_id = ? AND rating = 5", self.id).count
    else
      0
    end
  end

  def critiques_received
    Critique.joins(:project).where("projects.user_id = ?", self.id).order("created_at DESC")
  end

  def critiques_likes
    likes = []
    self.critiques.each do |c|
      likes = likes + c.likes
    end
    likes
  end

  def recent_critiques_received(limit = 5)
    Critique.joins(:project).where(["projects.user_id = ?", self.id]).order(:created_at).limit(limit)
  end

  def num_helpful_critiques_needed
    10 - self.critiques_likes.count
  end

  def is_guest?
    self.username == "guest"
  end
end
