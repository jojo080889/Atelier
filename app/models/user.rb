class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :skill_level, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
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
end
