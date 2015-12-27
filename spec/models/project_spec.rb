require 'rails_helper'

RSpec.describe Project, type: :model do

  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "associations / relationships" do
    it { should have_many(:tickets).dependent(:delete_all) }
    it { should have_many(:roles).dependent(:delete_all) }
  end

  context "finding users relationships to a project" do
    let(:adele) { create(:user) }
    let(:tori) { create(:user) }
    let(:chrome_project) { create(:project) }

    before do
      assign_role!(adele, :manager, chrome_project)
      assign_role!(tori, :editor, chrome_project)
    end

    it "returns true if a user is associated to a given project" do
      expect(chrome_project.has_member?(adele)).to be_truthy
    end

    it "returns true if a user is a manager of a given project" do
      expect(chrome_project.has_manager?(adele)).to be_truthy
    end

    it "returns true if a user is an editor of a given project" do
      expect(chrome_project.has_editor?(tori)).to be_truthy
    end
  end
end
