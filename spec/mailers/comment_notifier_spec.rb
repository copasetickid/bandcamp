require "rails_helper"

RSpec.describe CommentNotifier, type: :mailer do
  describe "created" do
    let(:project) { create(:project) }
    let(:ticket_owner) { create(:user) }
    let(:ticket) do
      create(:ticket, project: project, author: ticket_owner)
    end

    let(:commenter) { create(:user) }
    let(:comment) do
      build(:comment, ticket: ticket, author: commenter)
    end

    let(:email) do
      CommentNotifier.created(comment, ticket_owner)
    end

    it "sends out an email notification about a new comment" do
      expect(email.to).to include ticket_owner.email
      title = "#{ticket.name} for #{project.name} has been updated."
      expect(email.body.to_s).to include title
      expect(email.body.to_s).to include "#{commenter.email} wrote:"
      expect(email.body.to_s).to include comment.text
    end
  end
 end
