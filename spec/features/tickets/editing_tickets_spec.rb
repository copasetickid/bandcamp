require "rails_helper"

RSpec.feature "Users can edit existing tickets" do
  let(:project) { create(:project) }
  let(:ticket)  { create(:ticket, project: project) }
end
