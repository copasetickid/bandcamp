require 'rails_helper'

RSpec.describe User, type: :model do
   let(:admin) { create(:user, :admin) }
 	
 	context "user's role" do 
	  it "checks if the user's role is an admin" do
	  	expect(admin.is_admin?).to be true
	  end
	end
end
