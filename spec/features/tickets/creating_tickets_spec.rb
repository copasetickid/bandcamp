require "rails_helper"

RSpec.feature "Users can create new tickets" do
	let(:user) { create(:user) }

	before do
		login_as(user)
		project = create(:project, name: "Google Chrome")
		assign_role!(user, :editor, project)
		visit project_path(project)
		click_link "New Ticket"
	end

	scenario "with valid attributes" do
		fill_in "Name", with: "Non-standards compliance"
		fill_in "Description", with: "My pages are smooth!"
		click_button "Create Ticket"

		expect(page).to have_content "Ticket has been created."
		within "#ticket" do
			expect(page).to have_content "Author: #{user.email}"
		end
	end

	scenario "when providing invalid attributes" do
		click_button "Create Ticket"

		expect(page).to have_content "Ticket has not been created."
		expect(page).to have_content "Name can't be blank"
		expect(page).to have_content "Description can't be blank"
	end

	scenario "with an invalid description" do
		fill_in "Name", with: "Non-standards compliance"
		fill_in "Description", with: "IT sucks"
		click_button "Create Ticket"

		expect(page).to have_content "Ticket has not been created."
		expect(page).to have_content "Description is too short"
	end

	scenario "with an attachment" do 
		fill_in "Name", with: "On my mind"
		fill_in "Description", with: "5th track from Delrium"
		attach_file "File", "spec/fixtures/track.txt"
		click_button "Create Ticket"

		expect(page).to have_content "Ticket has been created."

		within "#ticket .attachment" do
			expect(page).to have_content "track.txt"
		end  
	end

	scenario "persiting file uploads across form displays" do 
		attach_file "File", "spec/fixtures/track.txt" 
		click_button "Create Ticket"

		fill_in "Name", with: "Don't Panic"
		fill_in "Description", with: "Add 11th track from Delrium"
		click_button "Create Ticket" 

		within "#ticket .attachment" do 
			expect(page).to have_content "track.txt"
		end
	end
end
