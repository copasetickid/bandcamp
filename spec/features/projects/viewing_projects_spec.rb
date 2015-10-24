require "rails_helper"

RSpec.feature "Users can view projects" do
	scenario 'with the project details' do
	  project = create(:project)

	  visit root_path
	  click_link project.name
	  expect(page.current_url).to eq project_url(project)
	end
end