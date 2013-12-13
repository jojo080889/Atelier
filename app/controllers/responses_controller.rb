class ResponsesController < ApplicationController
  def new
    @response = Response.new
    @entry = Entry.find(params[:entry_id])
    @project = @entry.project
    @critique = Critique.find(params[:critique_id])

    respond_to do |format|
      format.js
    end
  end

  def create
    @entry = Entry.find(params[:entry_id])
    @critique = Critique.find(params[:critique_id])
    @response = @critique.responses.new(params[:response])
    @response.user_id = current_user.id

    respond_to do |format|
      if @response.save
        if params[:response_like] == "true"
          @critique.liked_by current_user
        else
          @critique.unliked_by current_user
        end
        if (current_user.id != @critique.user.id)
          NotificationMailer.response_received_email(@critique).deliver
        end
        format.html { redirect_to project_entry_path(@entry.project, @entry), notice: 'Critique response was successfully created.' }
      end
    end
  end

  def edit
    @entry = Entry.find(params[:entry_id])
    @project = @entry.project
    @critique = Critique.find(params[:critique_id])
    @response = Response.find(params[:id])

    respond_to do |format|
      format.js
    end
  end
 
  def update
    @entry = Entry.find(params[:entry_id])
    @critique = Critique.find(params[:critique_id])
    @response = Response.find(params[:id])

    respond_to do |format|
      if @response.update_attributes(params[:response])
        format.html { redirect_to project_entry_path(@entry.project, @entry), notice: 'Critique response was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @entry = Entry.find(params[:entry_id])
    @critique = Critique.find(params[:critique_id])
    @response = Response.find(params[:id])
    @response.destroy

    respond_to do |format|
      format.html { redirect_to project_entry_path(@entry.project, @entry), notice: "Critique response was successfully deleted." }
      format.json { head :no_content }
    end
  end
end
