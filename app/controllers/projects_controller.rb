class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :authenticate_user!, :only => :show
  load_and_authorize_resource
  skip_authorize_resource :only => :show

  def index
    @order_clause = "critiques_count"
    @projects = Project.order(@order_clause)
    @mentoring_projects = Project.get_mentoring(@order_clause, current_user)
    @rec_projects = Project.get_recommended(@order_clause, current_user)
  end

  def show
    @project = Project.find(params[:id])
    @folder = @project.folder
    @critique = Critique.new
    @helpful_crits = @project.get_voted Critique
  end

  def new
    @project = Project.new
    @critique_options = current_user.recent_critiques_received
  end

  def edit
    @project = Project.find(params[:id])
    @folder = @project.folder
    @critique_options = @project.critique_options
  end

  def create
    @project = Project.new(params[:project])
    @project.user_id = current_user.id

    respond_to do |format|
      if @project.save
        
        # Like the critiques that were picked
        @picked_crits = params[:critique]
        if !@picked_crits.nil?
          @picked_crits.each_key do |key|
            crit = Critique.find(key)
            crit.liked_by @project
          
            if (current_user.id != crit.user.id)
              NotificationMailer.crit_marked_email(crit, @project).deliver
            end
          end
        end

        format.html { redirect_to rate_critiques_path, notice: 'Project was successfully created.' }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.find(params[:id])
    @folder = @project.folder

    respond_to do |format|
      if @project.update_attributes(params[:project])
        # Reset the critiques liked by this project
        @crits = @project.get_voted Critique
        @crits.each {|c| c.unliked_by @project}

        # Like the critiques that were picked
        @picked_crits = params[:critique]
        if !@picked_crits.nil? 
          @picked_crits.each_key do |key|
            crit = Critique.find(key)
            crit.liked_by @project
            
            if (current_user.id != crit.user.id)
              NotificationMailer.crit_marked_email(crit, @project).deliver
            end
          end
        end

        format.html { redirect_to project_path(@project), notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @folder = @project.folder
    @project.destroy

    respond_to do |format|
      destination = @folder.nil? ? current_user : @folder
      format.html { redirect_to destination, notice: "Project was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def like
    @project = Project.find(params[:project_id])
    @project.liked_by current_user

    respond_to do |format|
      format.js
    end
  end

  def unlike
    @project = Project.find(params[:project_id])
    @project.unliked_by current_user

    respond_to do |format|
      format.js
    end
  end

  def sort
    @scope = params[:scope]
    @order_by = params[:order_by]
    @order_clause = Project.get_order_clause(@order_by)
    @user = User.find_by_username(params[:username]) if !params[:username].nil?
    @show_name = (@scope != "users")

    if @scope == "all"
      @projects = Project.order(@order_clause)
    elsif @scope == "mentoring"
      @projects = Project.get_mentoring(@order_clause, current_user)
    elsif @scope == "recommended"
      @projects = Project.get_recommended(@order_clause, current_user)
    elsif @scope == "users"
      @projects = Project.get_by_user(@order_clause, @user)
    end

    respond_to do |format|
      format.js
    end
  end
end
