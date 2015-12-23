require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
	let(:project) { create(:project) }
	let(:user) { create(:user) }

	

	describe "POST #create" do 
		context "for editors" do 
			before :each do 
				assign_role!(user, :editor, project)
				sign_in user 
			end

			it "can create tickets, but not tag them" do 
				post :create, ticket: { name: "New ticket!", description: "Brand spankin' new", tag_names: "these are tags" },
							project_id: project.id 
				expect(Ticket.last.tags).to be_empty
			end
		end

		context "for viewers" do 
			before :each do 
				assign_role!(user, :viewer, project)
				sign_in user 
			end

			it "does not allow a ticket to be created" do 
				post :create, ticket: { name: "New ticket!", description: "Brand spankin' new", tag_names: "these are tags" },
							project_id: project.id 
				expect(response.status).to eq 302
			end
		end


	end
end
