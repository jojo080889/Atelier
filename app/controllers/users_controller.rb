class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def show
    @user = User.find_by_username(params[:id])
  end
end
