require_dependency 'skill_level'

class User < ActiveRecord::Base
  has_merit

  has_many :folders, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :critiques, :dependent => :destroy
  has_many :critique_ratings, :dependent => :destroy

  acts_as_voter

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true
  validates_presence_of :birthday, :on => :create
  validate :birthday_older_than_18
  validates :consented, :acceptance => true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :consented, :username, :skill_level_id, :email, :password, :password_confirmation, :birthday, :remember_me
  
  def to_param
    username
  end

  def name
    username
  end

  def to_s
    name
  end

  # A custom validation to check that all users are 18 or older
  def birthday_older_than_18
    now = Time.now.utc.to_date
    if !birthday.nil? 
      age = now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
    end
    errors.add(:birthday, "must show that you are 18 or older.") if birthday.nil? || age < 18
  end

  # Users can critique if they are a guest or if they are a logged in user with the right
  # skill level.
  def can_critique?(project)
    (self.is_guest? || (self.id != project.user.id && (SkillLevel.compare(self.skill_level, project.user.skill_level) || SkillLevel.compare(self.skill_level.lower_tier, project.user.skill_level))))
  end

  # Users can rate projects if they are a logged in user with a higher level than
  # the person posting the project
  def can_rate?(project)
    (!self.is_guest? && (self.id != project.user.id && (SkillLevel.compare_strict(self.skill_level, project.user.skill_level) || SkillLevel.compare_strict(self.skill_level.lower_tier, project.user.skill_level))))
  end

  # Gets the number of unique users that gave this user a rating of the
  # given skill level on any project
  def critiquers(skill_level)
    Critique.select("COUNT(critiques.id)").joins(:project).where("projects.user_id = ? AND rating = ?", self.id, SkillLevel.find_by_name_key(skill_level).id).group("critiques.user_id").length
  end

  # Gets number of ratings for the given skill level
  # If unique is true, gets the number of projects with at least
  # one rating of the given skill level (rather than the number of
  # critiques)
  def tier_ratings(skill_level, unique = false)
    if unique
      Critique.select("count(critiques.id)").joins(:project).where("projects.user_id = ? AND rating = ?", self.id, SkillLevel.find_by_name_key(skill_level).id).group("projects.id").length
    else
      Critique.joins(:project).where("projects.user_id = ? AND rating = ?", self.id, SkillLevel.find_by_name_key(skill_level).id).count
    end
  end

  # Gets the number of ratings contributing to the next tier
  def next_tier_ratings
    self.tier_ratings(self.skill_level.higher_tier.name_key, true)
  end

  # Gets the number of ratings needed to get to the next tier
  def next_tier_ratings_needed
    [2 - self.next_tier_ratings, 0].max
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

  # Returns a count of critique ratings received
  # at a certain level. If unique is true, only includes
  # one rating of that level per critique.
  def critique_ratings_count(skill_level, unique = true)
    result = self.critiques.joins(:critique_ratings).where('critique_ratings.rating_id = ?', SkillLevel.find_by_name_key(skill_level).id)
    result = result.uniq if unique
    result.count
  end

  def is_guest?
    self.username == "guest"
  end
  
  def admin?
    self.forem_admin
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

  # Check all requirements for badges manually.
  # Make sure this matches up with the badge rules.
  def check_for_badges!
    skill_level = self.skill_level.name_key.to_sym

    # BEGINNER
    if skill_level == :beginner && self.tutorial_done?
      self.add_badge(1)
    end
    
    if skill_level == :beginner && self.tier_ratings(:intermediate, true) >= 1
      self.add_badge(8)
    end

    if skill_level == :beginner && (self.tier_ratings(:intermediate, true) >= 2 && self.critiquers(:intermediate) >= 2)
      self.add_badge(9)
    end

    if skill_level == :beginner && self.projects.count >= 1
      self.add_badge(3)
    end

    if skill_level == :beginner && self.projects.count >= 2
      self.add_badge(4)
    end

    if skill_level == :beginner && self.critique_ratings_count(:intermediate, true) >= 3
      self.add_badge(12)
    end

    # INTERMEDIATE BADGES
    if skill_level == :intermediate && self.projects.count >= 4
      self.add_badge(5)
    end

    if skill_level == :intermediate && self.tier_ratings(:advanced, true) >= 1
      self.add_badge(10)
    end

    if skill_level == :intermediate && (self.tier_ratings(:advanced, true) >= 2 && self.critiquers(:advanced) >= 2)
      self.add_badge(11)
    end 
    
    if skill_level == :intermediate && self.critique_ratings_count(:advanced, true) >= 3
      self.add_badge(13)
    end
  end
end
