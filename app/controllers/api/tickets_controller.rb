class API::TicketsController < API::ApplicationController
	before_action :set_project
	before_action :set_ticket, only: [ :show, :update, :destroy ]

	def show
		authorize @ticket, :show?
		render json: @ticket
	end

	def create
		@ticket = @project.tickets.build(ticket_params)
		authorize @ticket, :create?

		if @ticket.save
			render json: @ticket, status: 201
		else
			render json: { errors: @ticket.errors.full_messages }, status: 422
		end
	end

	def update
		authorize @ticket, :update?

		if @ticket.update(ticket_params)
			render json: @ticket, status: 201
		else
			render json: { errors: @ticket.errors.full_messages }, status: 422
		end

	end

	def destroy

		authorize @ticket, :destroy?

		@ticket.destroy

		render json: { success: "Ticket has been deleted." }, status: 201
	end

	private

	def set_project
		@project = Project.find(params[:project_id])
	end

	def ticket_params
		params.require(:ticket).permit(:name, :description)
	end

	def set_ticket
		@ticket = @project.tickets.find(params[:id])
	end
end
