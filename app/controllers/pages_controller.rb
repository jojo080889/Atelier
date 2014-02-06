class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => :dashboard
  
  def dashboard
    @available_badges = current_user.skill_level.badges
    @earned_badges = current_user.badges
  end

  def about
  end
end
