class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => :dashboard
  
  def dashboard
  end

  def about
  end
end
