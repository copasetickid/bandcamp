require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
	it "handles a missing project correctly" do
		get :show, id: "not-here"

		expect(response).to redirect_to(projects_path)

		message = "The project you were looking for could not be found."
		expect(flash[:alert]).to eq message
	end

  it "handles permission errors by redirecting to a safe place" do
    project = create(:project)

    get :show, id: project

    expect(response).to redirect_to(root_path)
    message = "You aren't allowed to do that."
    expect(flash[:alert]).to eq message
  end

   describe "POST #members" do 
    let(:user) { create(:user) }
    let(:tori) { create(:user) }
    let(:project) { create(:project) }

    context "as an a manager of a project" do
      before do 
        assign_role!(user, :manager, project)
        sign_in user
      end

      it "can add users to the project" do 
        post :collaborators, id: project
        project.reload
        expect(project.roles.length).to eq 2
      end

    end
  end
end
