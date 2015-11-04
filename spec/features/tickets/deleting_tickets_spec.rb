require "rails_helper"

RSpec.feature "Users can edit existing tickets" do
  let(:author) { create(:user) }
  let(:project) { create(:project) }
  let(:ticket)  do
    create(:ticket, project: project, author: author)
  end

  before do
    login_as(author)
    assign_role!(author, :manager, project)
    visit project_ticket_path(project, ticket)
  end

  scenario "successfully" do
    click_link "Delete Ticket"

    expect(page).to have_content "Ticket has been deleted."

    expect(page.current_url).to eq project_url(project)
  end
end
