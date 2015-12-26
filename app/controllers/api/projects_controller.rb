class API::ProjectsController < API::ApplicationController
  before_action :project_lookup, only: [:show, :update, :destroy]
  def index
    @projects = policy_scope(Project)
    render json: @projects
  end

  def show
    authorize @project, :show?
    render json: @project
  end

  def create
    @project = Project.new(project_params)
    authorize @project, :create?

    if @project.save
      render json: @project, status: 201
    else
      render json: { errors: @project.errors.full_messages }, status: 422
    end
  end

  def update
    authorize @project, :update?

    if @project.update(project_params)
      render json: @project, status: 201
    else
      render json: { errors: @project.errors.full_messages }, status: 422
    end
  end

  def destroy
    authorize @project, :destroy?


    @project.destroy
    render json: {  success: "Project has been deleted."   }, status: 202
  end

  private

  def project_lookup
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Project not found" }, status: 404
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end

end
