class ProjectsController < ApplicationController
	before_action :project_lookup, only: [:edit, :show, :update]
	def index
		@projects = Project.all
	end

	def new
		@project = Project.new
	end

	def edit
	end

	def show
	end

	def create
		@project = Project.new(project_params)

		if @project.save 
			flash[:notice] = "Project has been created."
			redirect_to @project
		else
			flash.now[:alert] = "Project has not been created."
			render "new"
		end
	end

	def update
		if @project.update(project_params)
			flash[:notice] = "Project has been updated."
			redirect_to @project
		else
			flash.now[:alert] = "Project has not been updated."
			render "edit"
		end
	end

	def destroy
		@project = Project.find(params[:id])
		@project.destroy

		flash[:notice] = "Project has been deleted."
		redirect_to projects_path
	end

	private 

	def project_params
		params.require(:project).permit(:name, :description)
	end

	def project_lookup
		@project = Project.find(params[:id])
	end
end
