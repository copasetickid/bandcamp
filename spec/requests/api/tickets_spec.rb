require "rails_helper"

RSpec.describe "Tickets API" do
	let(:user) { create(:user) }
	let(:project) { create(:project) }
	let(:state) { create(:state, name: "Open") }
	let(:ticket) do
		create(:ticket, project: project, state: state)
	end

	before do
		assign_role!(user, :manager, project)
		user.generate_api_key
	end

	context "as an authenticated user" do
		let(:headers) do
			{ "HTTP_AUTHORIZATION" => "Token token=#{user.api_key}" }
		end

		it "retrieves a ticket's information" do
			get api_project_ticket_path(project, ticket, format: :json), {}, headers
			expect(response.status).to eq 200

			#expect(response).to  match_response_schema("ticket")
			json_response = TicketSerializer.new(ticket).to_json
			expect(response.body).to eq json_response
		end

		it "can create a ticket" do
			params = { format: "json", ticket: { name: "Test Ticket", description: "Just testing things out." } }
			post api_project_tickets_path(project, params), {}, headers
			expect(response.status).to eq 201

			json_response = TicketSerializer.new(Ticket.last).to_json
			expect(response.body).to eq json_response
		end

		it "cannot create a ticket with invalid data" do
			params = { format: "json", ticket: { name: "", description: ""} }
			post api_project_tickets_path(project, params), {}, headers

			expect(response.status).to eq 422
			json = { "errors" => [ "Name can't be blank", "Description can't be blank",
					"Description is too short (minimum is 10 characters)"] }

			expect(JSON.parse(response.body)).to eq json
		end

		context "Updating a ticket" do

			let(:existing_ticket) { create(:ticket, project: project) }


			it "saves it with valid data" do
				params = { format: "json", ticket: { name: "Lollipop" } }
				patch api_project_ticket_path(project, existing_ticket, params), {}, headers

				json_response = JSON.parse(response.body)
				expect(response.status).to eq 201
				expect(json_response["ticket"]["name"]).to eq "Lollipop"
			end

			it "cannot save a ticket with invalid data" do
				params = { format: "json", ticket: { name: "" } }
				patch api_project_ticket_path(project, existing_ticket, params), {}, headers

				json_response = JSON.parse(response.body)
				expect(response.status).to eq 422

				expect(json_response["errors"]).to eq ["Name can't be blank"]
			end
		end

		context "Deleting a ticket" do
			let(:existing_ticket) { create(:ticket, project: project) }

			it "destroys it with valid data" do
				delete api_project_ticket_path(project, existing_ticket), {}, headers
				json_response = JSON.parse(response.body)
				expect(response.status).to eq 201
				expect(json_response["success"]).to eq "Ticket has been deleted."
			end
		end


		context "without permission to view the project" do
			before do
				user.roles.delete_all
			end

			it "responds with a 403" do
				get api_project_ticket_path(project, ticket, format: :json), {}, headers
				expect(response.status).to eq 403
				error = { "error" => "Unauthorized" }
				expect(JSON.parse(response.body)).to eq error
			end
		end
	end

	context "as an unauthenticated user" do
		it "responds with a 401" do
			get api_project_ticket_path(project, ticket, form: :json)
			expect(response.status).to eq 401
			error = { "error" => "Unauthorized" }
			expect(JSON.parse(response.body)).to eq error
		end
	end
end
