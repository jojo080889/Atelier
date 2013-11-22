class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def manage
    @projects = Project.where(:user_id => current_user.id)
  end
end
