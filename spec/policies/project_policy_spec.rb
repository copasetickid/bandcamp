require 'rails_helper'

describe ProjectPolicy do

  let(:user) { User.new }

  subject { ProjectPolicy }

  context "policy_scope" do 
    subject { Pundit.policy_scope(user, Project) }

    let!(:project) { create(:project) }
    let(:user) { create(:user) }

    it "is empty for anonymous users" do 
      expect(Pundit.policy_scope(nil, Project)).to be_empty
    end

    it "includes projects a user is allowed to view" do 
      assign_role!(user, :viewer, project)
      expect(subject).to include(project) 
    end

    it "doesn't incude projects a user is not allowed to view" do 
      expect(subject).to be_empty
    end

    it "returns all projects for admins" do 
      user.admin! 
      expect(subject).to include(project)
    end
  end

  permissions :show? do
    let(:user) { create(:user) }
    let(:project) { create(:project) }

    it "blocks anonymous users" do
      expect(subject).not_to permit(nil, project)
    end

    it "allows viewers of the project" do
      assign_role!(user, :viewer, project)
      expect(subject).to permit(user, project)
    end

    it "allows editors of the project" do
      assign_role!(user, :editor, project)
      expect(subject).to permit(user, project)
    end

    it "allows managers of the project" do
      assign_role!(user, :manager, project)
      expect(subject).to permit(user, project)
    end

    it "allows admins" do
       admin = create(:user, :admin)
      expect(subject).to permit(admin, project)
    end

    it "does not allow users assigned to other projects" do
      other_project = create(:project)
      assign_role!(user, :manager, other_project)
      expect(subject).not_to permit(user, project)
    end
  end
end
