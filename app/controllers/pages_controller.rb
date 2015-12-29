class PagesController < ApplicationController
  skip_after_action :verify_authorized, :verify_policy_scoped 
  
  def home
  	redirect_to projects_path if user_signed_in?
  end
end
