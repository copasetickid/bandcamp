require 'rails_helper'

describe AttachmentPolicy do

  context "permissions" do
    subject { AttachmentPolicy.new(user, attachment) }

    let(:user) { create(:user) }
    let(:project) { create(:project) }
    let(:ticket) { create(:ticket, project: project) }
    let(:attachment) { create(:attachment, ticket: ticket) }

    context "for anonymous users" do
      let(:user) { nil }
      it { should_not permit_action :show }
    end

    context "for viewers of the project" do
      before { assign_role!(user, :viewer, project) }
      it { should permit_action :show }
    end

    context "for editors of the project" do
      before { assign_role!(user, :editor, project) }
      it { should permit_action :show }
    end

    context "for managers of the project" do
      before { assign_role!(user, :manager, project) }
      it { should permit_action :show }
    end

    context "for managers of other projects" do
      before do
         assign_role!(user, :manager, create(:project))
      end

      it { should_not permit_action :show }
    end

    context "for adminstrators" do
      let(:user) { create(:user, :admin) }
      it { should permit_action :show }
    end
  end
end
