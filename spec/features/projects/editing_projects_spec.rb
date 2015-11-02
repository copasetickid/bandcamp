require "rails_helper"

RSpec.feature "Users can edit existing projects" do
	let(:user) { create(:user) }
	let(:project) { create(:project) }

	before do
	  login_as(user)
	  assign_role!(user, :manager, project)
	  visit root_path
	  click_link project.name
	  click_link "Edit Project"
	end

	scenario 'with valid attributes' do
	  fill_in "Name", with: "Same Love"
	  click_button "Update Project"

	  expect(page).to have_content "Project has been updated."
	  expect(page).to have_content "Same Love"
	end

	scenario 'when providing invalid attributes' do
	  fill_in "Name", with: ""
	  click_button "Update Project"

	  expect(page).to have_content "Project has not been updated."
	end
end
