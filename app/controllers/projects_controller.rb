class ProjectsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    if params[:tag]
      @projects = Project.tagged_with(params[:tag])
    else
      @projects = Project.all.order("updated_at DESC").paginate(page: params[:page], per_page: 18)
    end
  end

  def show
    @project = Project.find(params[:id])
    @commentable = @subscribable = @project
    @comments = @commentable.comments
    @comment = Comment.new
    @subscriptions = @subscribable.subscriptions
    @subscription = Subscription.new
  end

  def create
    @project = current_user.projects.create(project_params)
    if @project.save
      redirect_to @project, notice: 'Your project post was successful!'
    else
      notice = 'Something went wrong when we tried to add your project...'
      render action: 'new'
    end
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = current_user.projects.find(params[:id])
    if @project.update_attributes!(project_params)
      redirect_to @project, notice: 'Your project details were updated!'
    else
      redirect_to @project, notice: 'Something went wrong when we tried to update your project...'
    end
  end

  def destroy
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :image_url, :location, :tag_list)
  end
end
