class ResponsesController < ApplicationController
  load_and_authorize_resource 
  skip_authorize_resource :only => [:new, :create]
  skip_before_filter :verify_authenticity_token, :only => :new

  def new
    @response = Response.new
    @project = Project.find(params[:project_id])
    @critique = Critique.find(params[:critique_id])

    respond_to do |format|
      format.js
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @critique = Critique.find(params[:critique_id])
    @response = @critique.responses.new(params[:response])
    @response.user_id = current_or_guest_user.id

    respond_to do |format|
      if @response.save
        if (!@critique.user.nil? && current_or_guest_user.id != @critique.user.id)
          NotificationMailer.response_received_email(@critique).deliver
        end
        format.html { redirect_to project_path(@project), notice: 'Reply was successfully created.' }
      else
        format.html { redirect_to project_path(@project), notice: 'Something went wrong when creating your reply. Please try again.' }
      end
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @critique = Critique.find(params[:critique_id])
    @response = Response.find(params[:id])

    respond_to do |format|
      format.js
    end
  end
 
  def update
    @project = Project.find(params[:project_id])
    @critique = Critique.find(params[:critique_id])
    @response = Response.find(params[:id])

    respond_to do |format|
      if @response.update_attributes(params[:response])
        format.html { redirect_to project_path(@project), notice: 'Critique response was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @project = Project.find(params[:project_id])
    @critique = Critique.find(params[:critique_id])
    @response = Response.find(params[:id])
    @response.destroy

    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: "Critique response was successfully deleted." }
      format.json { head :no_content }
    end
  end
end
