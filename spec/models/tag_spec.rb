require 'rails_helper'

RSpec.describe Tag, type: :model do
  	describe "associations / relationships" do 
  	    it { should have_many :tag_tickets }
    	it { should have_many(:tickets).through(:tag_tickets) }
	end
end
