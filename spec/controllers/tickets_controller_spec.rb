require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
	let(:project) { create(:project) }
	let(:user) { create(:user) }

	describe "GET #new" do 
		context "when signed in" do 
			before :each do 
				assign_role!(user, :editor, project)
				sign_in user
			end

			it "assigns a ticket to @ticket" do 
				get :new, project_id: project.id
				expect(assigns(:ticket)).to be_a_new(Ticket)
			end
		end
	end

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
				expect { post :create, ticket: { name: "New ticket!", description: "Brand spankin' new", tag_names: "these are tags" },
							project_id: project.id }.not_to change{Ticket.count}
			end
		end

		context "for managers of the project" do 
			before :each do 
				assign_role!(user, :manager, project)
				sign_in user 
			end

			it "can create tickets with tags" do 
				post :create, ticket: { name: "New ticket!", description: "Brand spankin' new", tag_names: "these are tags" },
							project_id: project.id 
				expect(Ticket.last.tags).not_to be_empty
			end
		end

		context "for admins" do 
			before :each do 
				user.admin!
				sign_in user 
			end

			it "can create tickets with tags" do 
				post :create, ticket: { name: "New ticket!", description: "Brand spankin' new", tag_names: "these are tags" },
							project_id: project.id 
				expect(Ticket.last.tags).not_to be_empty
			end
		end

	end

	describe "PUT #update" do 
		let(:existing_ticket) { create(:ticket, project: project) }
		context "for editors" do 
			before :each do 
				assign_role!(user, :editor, project)
				sign_in user 
			end

			it "does not allow them to update a ticket" do 
				put :update, ticket: { name: "Changed it" }, id: existing_ticket.id, project_id: project.id
				expect(response.status).to eq 302
			end
		end

		context "for managers of the project" do 
			before :each do 
				assign_role!(user, :manager, project)
				sign_in user 
			end

			it "allows them to update a ticket with valid params" do 
				put :update, ticket: { name: "Changed it" }, id: existing_ticket.id, project_id: project.id
				existing_ticket.reload
				expect(flash[:notice]).to eq "Ticket has been updated."
				should redirect_to project_ticket_path(project, existing_ticket)
			end

			it "does not update the ticket with missing params" do 
				put :update, ticket: { name: "" }, id: existing_ticket.id, project_id: project.id
				expect(flash[:alert]).to eq "Ticket has not been updated."
				should render_template "edit"
			end
		end
	end
end
