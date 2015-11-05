require "rails_helper"

RSpec.feature "Admins can manage a user's roles" do 
	let(:admin) { create(:user, :admin) }
	let(:user) { create(:user) }

	let!(:chrome) { create(:project, name: "Google Chrome") }
	let!(:sunkist) { create(:project, name: "Pineapple") }

	before do 
		login_as(admin)
	end

	scenario "when assigning roles to an existing user" do 
		visit admin_user_path(user)
		click_link "Edit User"

		select "Viewer", from: chrome.name 
		select "Manager", from: sunkist.name 

		click_button "Update User"
		expect(page).to have_content "User has been updated" 

		click_link user.email
		expect(page).to have_content "#{chrome.name}: Viewer"
		expect(page).to have_content "#{sunkist.name}: Manager"
	end

	scenario "when assigning roles to a new user" do 
		visit new_admin_user_path 

		fill_in "Email", with: "newuser@bandcamp.com"
		fill_in "Password", with: "password"

		select "Editor", from: chrome.name 
		click_button "Create User"

		click_link "newuser@bandcamp.com"
		expect(page).to have_content "#{chrome.name}: Editor"
		expect(page).not_to have_content sunkist.name
	end
end