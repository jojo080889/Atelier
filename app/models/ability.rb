class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, :all
    can :create, Critique

    unless user.id.blank?
      # Owners of folders can...
      can :manage, Folder, :user_id => user.id

      # Owners of projects can...
      can :manage, Project, :user_id => user.id

      # Owners of critiques can...
      can :manage, Critique, :user_id => user.id

      # Owners of responses can...
      can :manage, Response, :user_id => user.id
    end
  end
end
