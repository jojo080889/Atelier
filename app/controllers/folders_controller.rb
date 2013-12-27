class FoldersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
  end

  def show
    @folder = Folder.find(params[:id])
  end

  def new
    @folder = Folder.new
  end

  def edit
    @folder = Folder.find(params[:id])
  end

  def create
    @folder = Folder.new(params[:folder])
    @folder.user_id = current_user.id

    respond_to do |format|
      if @folder.save
        format.html { redirect_to @folder, notice: 'Folder was successfully created.' }
      else
        format.html { render action: "new" }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @folder = Folder.find(params[:id])

    respond_to do |format|
      if @folder.update_attributes(params[:folder])
        format.html { redirect_to @folder, notice: 'Folder was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @folder = Folder.find(params[:id])
    @folder.destroy

    respond_to do |format|
      format.html { redirect_to current_user, notice: "Folder was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def sort
    @order_by = params[:order_by]
    @scope = params[:scope]
    @user = User.find_by_username(params[:username]) if !params[:username].nil?

    @order_clause = Project.get_order_clause(@order_by)

    if @scope == "all"
      @projects = Project.get_all(@order_clause)
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
