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
	end
end