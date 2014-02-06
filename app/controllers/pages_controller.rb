class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => :dashboard
  
  def dashboard
    @available_badges = current_user.skill_level.badges
    @earned_badges = current_user.badges

    @tutorial_not_done = current_user.skill_level.lowest? && !current_user.tutorial_done?
    @too_many_projects = current_user.critiques.count < current_user.projects.count
  end

  def about
  end
end
