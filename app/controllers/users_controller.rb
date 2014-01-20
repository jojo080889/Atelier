class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :find_by => :username
  
  def show
    @user = User.find_by_username(params[:id])
    @projects = Project.get_by_user("critiques_count ASC", @user)
    @available_badges = @user.skill_level.badges
    @earned_badges = @user.badges
  end
end
