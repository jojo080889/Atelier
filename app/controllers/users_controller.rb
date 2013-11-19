class UsersController < ApplicationController
  def manage
    @projects = Project.where(:user_id => current_user.id)
  end
end
