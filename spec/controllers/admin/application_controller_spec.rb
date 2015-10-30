require 'rails_helper'

RSpec.describe Admin::ApplicationController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  context "non-admin users" do
    it "are not able to access the admin root page" do
      get :index

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq "You must be admin to do that."
    end
  end

end
