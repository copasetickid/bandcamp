require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end

    context "Authenticated users" do 
    	let(:user) { create(:user) }
    	let(:admin) { create(:user, :admin) }
    	
    	it "redirects users to the Projects page" do 
    		sign_in user
    		get :home
    		expect(response).to redirect_to projects_path
    	end

    	it "redirects admins to the Projects page" do 
    		sign_in admin 
    		get :home
    		expect(response).to redirect_to projects_path
    	end
    end
  end
end
