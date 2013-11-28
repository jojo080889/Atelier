class CritiquesController < ApplicationController
  load_and_authorize_resource

  def create
    @project = Project.find(params[:project_id])
    @critique = @project.critiques.create(params[:critique])
    @critique.user_id = current_user.id

    respond_to do |format|
      if @critique.save
        NotificationMailer.critique_received_email(@project).deliver
        format.html { redirect_to project_path(@project), notice: 'Critique was successfully created.' }
      else
        format.html { render action: "new" }
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

    respond_to do |format|
      if @critique.update_attributes(params[:critique])
        format.html { redirect_to @project, notice: 'Critique was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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
