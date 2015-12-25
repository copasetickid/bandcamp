require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe "validations" do
  	it { validate_presence_of :name }
  	it { should validate_length_of :description }
  end

  describe "relationships / associations " do
  	it { should belong_to :project }
  	it { should belong_to :state }
  	it { should belong_to(:author).class_name("User") }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should have_many :comments }
    it { should have_many :tag_tickets }
    it { should have_many(:tags).through(:tag_tickets) }
    it { should have_many :ticket_watchers }
    it { should have_many(:watchers).through(:ticket_watchers).source(:user) }
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:attachments) }
  end

  context "creating a new ticket" do
    let!(:active_state) { create(:state, :default) }
    let!(:user) { create(:user) }
    let(:new_ticket) { create(:ticket, author: user) }

    it "assigns a default state" do
      expect(new_ticket.state).to_not be_nil
    end

    it "adds the author to the watch list" do
      expect(new_ticket.watchers).to include user
    end
  end
end
