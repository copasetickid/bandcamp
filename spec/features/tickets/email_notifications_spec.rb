require "rails_helper"

RSpec.feature "Users can recieve notifications about ticket updates" do
  let(:ryan) { create(:user, email: "ryan@example.com") }
  let(:adele) { create(:user, email: "adele@example.com") }
  let(:project) { create(:project) }
  let(:ticket) do
    create(:ticket, project: project, author: adele)
  end

  before do
    assign_role!(adele, :manager, project)
    assign_role!(ryan, :manager, project)

    login_as(ryan)
    visit project_ticket_path(project, ticket)
  end

  scenario "ticket authors automatically recieve notifications" do
    fill_in "Text", with: "Is it out yet?"
    click_button "Create Comment"

    email = find_email!(adele.email)
    expected_subject = "Bandcamp #{project.name} - #{ticket.name}"
    expect(email.subject).to eq expected_subject

    click_first_link_in_email(email)
    expect(current_path).to eq project_ticket_path(project, ticket)
  end

  scenario "comment authors are automatically subscribed to a ticket" do
    fill_in "Text", with: "Is it out yet?"
    click_button "Create Comment"
    click_link "Sign out"

    reset_mailer

    login_as(adele)
    visit project_ticket_path(project, ticket)
    fill_in "Text", with: "Not yet - sorry!"
    click_button "Create Comment"

    expect(page).to have_content "Comment has been created."
    expect(unread_emails_for(ryan.email).count).to eq 1
    expect(unread_emails_for(adele.email).count).to eq 0
  end
end
