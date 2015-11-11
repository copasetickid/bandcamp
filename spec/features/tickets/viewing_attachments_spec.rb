require "rails_helper"

RSpec.feature "Users can view a ticket's attached files" do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:ticket) { create(:ticket, project: author: user) }
  let!(:attachment) { create(: attachment, ticket: ticket, file_to_attach: "spec/fixtures/hello.txt") }

  before do
    assign_role!(user, :viewer, project)
    login_as(user)
  end

  scenario "successfully" do
    visit project_ticket_path(project, ticket)
    click_link "hello.txt"

    expect(current_path).to eq attachment_path(attachment)
    expect(page).to have_content "Hello, it's me"
  end
end
