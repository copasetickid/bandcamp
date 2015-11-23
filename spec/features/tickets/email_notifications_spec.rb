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
end
