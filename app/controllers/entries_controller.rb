class EntriesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
  end

  def show
    @entry = Entry.find(params[:id])
    @project = @entry.project
    @critique = Critique.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entry }
    end
  end

  def new
    @entry = Entry.new
    @project = Project.find(params[:project_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entry }
    end
  end

  def edit
    @entry = Entry.find(params[:id])
    @project = @entry.project
  end

  def create
    @entry = Entry.new(params[:entry])
    @project = Project.find(params[:project_id])
    @entry.user_id = current_user.id
    @entry.project_id = @project.id

    respond_to do |format|
      if @entry.save
        format.html { redirect_to project_entry_path(@entry), notice: 'Project entry was successfully created.' }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = Entry.find(params[:id])

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        format.html { redirect_to @entry, notice: 'Project entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url }
      format.json { head :no_content }
    end
  end

  def like
    @entry = Entry.find(params[:entry_id])
    @entry.liked_by current_user

    respond_to do |format|
      format.js
    end
  end

  def unlike
    @entry = Entry.find(params[:entry_id])
    @entry.unliked_by current_user

    respond_to do |format|
      format.js
    end
  end
end
