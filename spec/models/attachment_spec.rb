require 'rails_helper'

RSpec.describe Attachment, type: :model do
  	describe "associations / relationships" do
   		it { should belong_to :ticket }
    end
end
