require "rails_helper"

RSpec.feature "Users can view projects" do
  let(:user) { create(:user) }
  let(:project) { create(:project, name: "Bunny") }

  before do
    login_as(user)
    assign_role!(user, :viewer, project)
  end

	scenario 'with the project details' do
	  visit root_path
	  click_link project.name
	  expect(page.current_url).to eq project_url(project)
	end
end
