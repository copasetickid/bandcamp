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
  end
end
