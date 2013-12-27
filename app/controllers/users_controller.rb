class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :find_by => :username
  
  def show
    @user = User.find_by_username(params[:id])
    @entries = Entry.get_by_user("critiques_count ASC", @user)
  end
end
