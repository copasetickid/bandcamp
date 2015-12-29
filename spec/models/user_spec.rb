require 'rails_helper'

RSpec.describe User, type: :model do
 	describe "associations / relationships" do
   		it { should have_many :roles }
    end

    describe "enum attributes" do 
    	it { should define_enum_for(:role) }
    end
	
 	context "user's role" do 
 	  let(:admin) { create(:user, :admin) }

	  it "checks if the user's role is an admin" do
	  	expect(admin.is_admin?).to be true
	  end
	end
end
