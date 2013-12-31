require_dependency 'skill_level'

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
  attr_accessible :username, :skill_level_id, :email, :password, :password_confirmation, :birthday, :remember_me
  
  def to_param
    username
  end

  def name
    username
  end

  def to_s
    name
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
    (self.is_guest? || (self.id != project.user.id && (SkillLevel.compare(self.skill_level, project.user.skill_level) || SkillLevel.compare(self.skill_level.lower_tier, project.user.skill_level))))
  end

  # Gets the number of ratings contributing to the next tier
  def next_tier_ratings
    Critique.joins(:project).where("projects.user_id = ? AND rating = ?", self.id, self.skill_level.higher_tier.id).count
  end

  # Gets the number of ratings needed to get to the next tier
  def next_tier_ratings_needed
    [5 - self.next_tier_ratings, 0].max
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

  def helpful_critiques_needed
    [10 - self.critiques_likes.count, 0].max
  end

  def is_guest?
    self.username == "guest"
  end

  def skill_level
    SkillLevel.find(self.skill_level_id)
  end

  def has_skill_level?(level)
    raise "Invalid skill level #{level}" unless SkillLevel.valid_level?(level)
    SkillLevel.compare_exact(self.skill_level, SkillLevel.find_by_name_key(level))
  end

  def change_skill_level!(level)
    raise "Invalid skill level #{level}" unless SkillLevel.valid_level?(level)
    self.skill_level_id = SkillLevel.find_by_name_key(level).id
    self.save!
  end

  def check_for_user_level!
    debugger
    if (self.helpful_critiques_needed <= 0 && self.next_tier_ratings_needed <= 0)
      self.change_skill_level!(self.skill_level.higher_tier.name_key.to_sym)   
    end
  end
end
