class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @order_clause = "critiques_count"

    @projects = Project.get_all(@order_clause)
    @mentoring_projects = Project.get_mentoring(@order_clause, current_user)
    @rec_projects = Project.get_recommended(@order_clause, current_user)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])
    @project.user_id = current_user.id

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def sort
    @order_by = params[:order_by]
    @scope = params[:scope]

    @order_clause = Project.get_order_clause(@order_by)

    if @scope == "all"
      @projects = Project.get_all(@order_clause)
    elsif @scope == "mentoring"
      @projects = Project.get_mentoring(@order_clause, current_user)
    elsif @scope == "recommended"
      @projects = Project.get_recommended(@order_clause, current_user)
    elsif @scope == "mine"
      @projects = Project.get_mine(@order_clause, current_user)
    end

    respond_to do |format|
      format.js
    end
  end
end
