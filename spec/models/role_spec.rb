require 'rails_helper'

RSpec.describe Role, type: :model do
    describe "associations / relationships" do
   		it { should belong_to :project }
   		it { should belong_to :user }
    end

    describe "enum attributes" do 
    	it { should define_enum_for(:role) }
    end
end
