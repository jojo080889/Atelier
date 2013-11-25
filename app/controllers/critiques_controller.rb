class CritiquesController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @critique = @project.critiques.create(params[:critique])
    @critique.user_id = current_user.id

    respond_to do |format|
      if @critique.save
        format.html { redirect_to project_path(@project), notice: 'Critique was successfully created.' }
      else
        format.html { render action: "new" }
        format.json { render json: @critique.errors, status: :unprocessable_entity }
      end
    end
  end
end
