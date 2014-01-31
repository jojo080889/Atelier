class CritiquesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :create

  def create
    @project = Project.find(params[:project_id])
    @critique = @project.critiques.new(params[:critique])
    if current_or_guest_user.is_guest?
      @critique.rating = nil
    end
    if !current_or_guest_user.is_guest?
      @critique.skill_level_id = current_user.skill_level_id
    end
    @critique.user_id = current_or_guest_user.id
    if (params[:paintover_data] == "none" || params[:paintover_data].nil?)
      @critique.paintover = nil
    else
      @critique.save_paintover(params[:paintover_data])
    end
    if params[:critique][:started_at] != ""
      @critique.started_at = Time.at(params[:critique][:started_at].to_d)
    end

    respond_to do |format|
      if @critique.save
        NotificationMailer.critique_received_email(@project, @critique).deliver
        if URI(request.referer).path == new_project_critique_path(@project)
          destination = current_user
        else
          destination = project_path(@project)
        end
        format.html { redirect_to destination, notice: 'Critique was successfully created.' }
      else
        format.html { redirect_to project_path(@project), notice: 'There were errors creating your critique. Please try again.' }
        format.json { render json: @critique.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @critique = Critique.find(params[:id])

    respond_to do |format|
      format.js
    end
  end
 
  def update
    @project = Project.find(params[:project_id])
    @critique = Critique.find(params[:id])
    if (params[:paintover_data] == "none" || params[:paintover_data].nil?)
      @critique.paintover = nil
    else
      @critique.save_paintover(params[:paintover_data])
    end

    respond_to do |format|
      if @critique.update_attributes(params[:critique])
        format.html { redirect_to project_path(@project), notice: 'Critique was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to project_path(@project), notice: "There was a problem editing your critique. Please try again." }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @project = Project.find(params[:project_id])
    @critique = Critique.find(params[:id])
    @critique.destroy

    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: "Critique was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def like
    @critique = Critique.find(params[:critique_id])
    @critique.liked_by current_user
    NotificationMailer.critique_rated_email(@critique).deliver

    respond_to do |format|
      format.js
    end
  end

  def dislike
    @critique = Critique.find(params[:critique_id])
    @critique.disliked_by current_user

    respond_to do |format|
      format.js
    end
  end

  def rate
    # Check if there are recommended projects for the next page
    # and set the next button destination accordingly
    if Atelier::Application.config.skill_levels
      @next_project = Project.get_recommended(Project.get_order_clause("lowcritiques"), current_user).first
    else
      @next_project = Project.order(Project.get_order_clause("lowcritiques")).first
    end
    if @next_project.nil?
      @destination = new_none_critiques_path
    else
      @destination = new_project_critique_path(@next_project)
    end

    if Atelier::Application.config.skill_levels
      # Get a few random critiques by people of the same level as the user
      @critiques = Critique.where("skill_level_id = ? AND user_id <> ? AND guest_name IS NULL", current_user.skill_level.id, current_user.id).order("RANDOM()").limit(3)
      @critiques = @critiques.select { |c| !current_user.voted_for? c }
    else
      @critiques = Critique.where("user_id <> ? AND guest_name IS NULL", current_user.id).order("RANDOM()").limit(3)
    end
  end

  def rating
    @critique = Critique.find(params[:critique_id])
    @cr = CritiqueRating.new(:user_id => current_user.id, :critique_id => params[:critique_id], :rating_id => params[:rating])
    @cr.save
    
    respond_to do |format|
      format.js
    end
  end

  # Used when a user is prompted to create a critique after they
  # create their own project
  def new
    if Atelier::Application.config.skill_levels
      @projects = Project.get_recommended(Project.get_order_clause("lowcritiques"), current_user)
    else
      @projects = Project.order(Project.get_order_clause("lowcritiques"))
    end
    @project = Project.find(params[:project_id])
    if @projects.index(@project).nil?
      redirect_to root_path, notice: "You are not able to access that page. Sorry!"
    end
  end

  # When the user reaches the end of their recommended list
  def new_none
    @project = Project.get_recommended(Project.get_order_clause("lowcritiques"), current_user).first
  end

  def tutorial
  end

  def tutorial_check
    current_user.tutorial_done = true  
    current_user.save
    current_user.add_badge(1)
    
    respond_to do |format|
      format.js
    end
  end
end
