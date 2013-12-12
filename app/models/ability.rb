class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, :all

    unless user.id.blank?
      # Owners of entries can...
      can :manage, Entry, :user_id => user.id

      # Owners of critiques can...
      can :manage, Critique, :user_id => user.id

      # Owners of responses can...
      can :manage, Response, :user_id => user.id
    end
  end
end
