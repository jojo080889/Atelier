class EntriesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @order_clause = "critiques_count"
    @projects = Entry.order(@order_clause)
    @mentoring_projects = Entry.get_mentoring(@order_clause, current_user)
    @rec_projects = Entry.get_recommended(@order_clause, current_user)
  end

  def show
    @entry = Entry.find(params[:id])
    @project = @entry.project
    @critique = Critique.new
    @helpful_crits = @entry.get_voted Critique

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @entry }
    end
  end

  def new
    @entry = Entry.new
    @critique_options = current_user.recent_critiques_received

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entry }
    end
  end

  def edit
    @entry = Entry.find(params[:id])
    @project = @entry.project
    @critique_options = @entry.critique_options
  end

  def create
    @entry = Entry.new(params[:entry])
    @entry.user_id = current_user.id

    respond_to do |format|
      if @entry.save
        
        # Like the critiques that were picked
        @picked_crits = params[:critique]
        if !@picked_crits.nil?
          @picked_crits.each_key do |key|
            crit = Critique.find(key)
            crit.liked_by @entry
          
            if (current_user.id != crit.user.id)
              NotificationMailer.crit_marked_email(crit, @entry).deliver
            end
          end
        end

        format.html { redirect_to entry_path(@entry), notice: 'Project entry was successfully created.' }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = Entry.find(params[:id])
    @project = @entry.project

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        # Reset the critiques liked by this entry
        @crits = @entry.get_voted Critique
        @crits.each {|c| c.unliked_by @entry}

        # Like the critiques that were picked
        @picked_crits = params[:critique]
        if !@picked_crits.nil? 
          @picked_crits.each_key do |key|
            crit = Critique.find(key)
            crit.liked_by @entry
            
            if (current_user.id != crit.user.id)
              NotificationMailer.crit_marked_email(crit, @entry).deliver
            end
          end
        end

        format.html { redirect_to entry_path(@entry), notice: 'Project entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @project = @entry.project
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to @project, notice: "Project entry was successfully deleted." }
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

  def sort
    @scope = params[:scope]
    @order_by = params[:order_by]
    @order_clause = Entry.get_order_clause(@order_by)
    @user = User.find_by_username(params[:username]) if !params[:username].nil?
    @show_name = (@scope != "users")

    if @scope == "all"
      @entries = Entry.order(@order_clause)
    elsif @scope == "mentoring"
      @entries = Entry.get_mentoring(@order_clause, current_user)
    elsif @scope == "recommended"
      @entries = Entry.get_recommended(@order_clause, current_user)
    elsif @scope == "users"
      @entries = Entry.get_by_user(@order_clause, @user)
    end

    respond_to do |format|
      format.js
    end
  end
end
