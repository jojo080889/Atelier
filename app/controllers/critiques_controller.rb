class CritiquesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :create

  def create
    @project = Project.find(params[:project_id])
    @folder = @project.folder
    @critique = @project.critiques.new(params[:critique])
    @critique.user_id = current_or_guest_user.id
    if (params[:paintover_data] == "none" || params[:paintover_data].nil?)
      @critique.paintover = nil
    else
      @critique.save_paintover(params[:paintover_data])
    end

    respond_to do |format|
      if @critique.save
        NotificationMailer.critique_received_email(@project).deliver
        format.html { redirect_to project_path(@project), notice: 'Critique was successfully created.' }
      else
        format.html { redirect_to project_path(@project), notice: 'There were errors creating your critique. Please try again.' }
        format.json { render json: @critique.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @folder = @project.folder
    @critique = Critique.find(params[:id])

    respond_to do |format|
      format.js
    end
  end
 
  def update
    @project = Project.find(params[:project_id])
    @folder = @project.folder
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
    @folder = @project.folder
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

    respond_to do |format|
      format.js
    end
  end

  def unlike
    @critique = Critique.find(params[:critique_id])
    @critique.unliked_by current_user

    respond_to do |format|
      format.js
    end
  end
end
