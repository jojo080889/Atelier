class EntriesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @entries = Entry.all
  
    @mentoring_entries = Entry.joins(:critiques).uniq.where("critiques.user_id = ?", current_user)

    @rec_entries = Entry.joins(:user).where("users.id <> ? AND (users.skill_level = ? OR users.skill_level = ?)", current_user.id, current_user.skill_level, current_user.lower_tier)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entries }
    end
  end

  def show
    @entry = Entry.find(params[:id])
    @critique = Critique.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entry }
    end
  end

  def new
    @entry = Entry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entry }
    end
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def create
    @entry = Entry.new(params[:entry])
    @entry.user_id = current_user.id

    respond_to do |format|
      if @entry.save
        format.html { redirect_to user_path(current_user), notice: 'Project entry was successfully created.' }
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
