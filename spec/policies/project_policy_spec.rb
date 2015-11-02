require 'rails_helper'

describe ProjectPolicy do

  let(:user) { User.new }

  subject { ProjectPolicy }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :create? do
    pending "add some examples to (or delete) #{__FILE__}"
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
      assign_role!(user, :manger, project)
      expect(subject).to permit(user, project)
    end

    it "allows admins" do
       admin = create(:user, :admin)
      expect(subject).to permit(admin, project)
    end

    it "does not allow users assigned to other projects" do
      other_project = create(:project)
      assign_role!(user, :manger, other_project)
      expect(subject).not_to permit(user, project)
    end
  end

  permissions :update? do

    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
