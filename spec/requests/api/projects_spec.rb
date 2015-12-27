require 'rails_helper'

RSpec.describe "Projects API" do
  let(:user) { create(:user, :with_api_key) }
  let(:chrome_project) { create(:project) }
  let(:project) { create(:project, name: "25") }
  let(:ticket) do
    create(:ticket_with_state, project: chrome_project)
  end

  context "as an authenticated manager" do
    before do
      assign_role!(user, :manager, chrome_project)
    end

    let(:headers) do
      { "HTTP_AUTHORIZATION" => "Token token=#{user.api_key}" }
    end

    it "return all projects the user has permissions for" do
      get api_projects_path, {}, headers
      expect(json.length).to eq 1
    end

    it "returns a single project's information the user has permission for" do
      get api_project_path(chrome_project), {}, headers
      expect(response.status).to eq 200

      json_format = ProjectSerializer.new(chrome_project).to_json
      expect(response.body).to eq json_format
    end

    it "returns an error when the project is not found" do
      get api_project_path(5), {}, headers
      expect(response.status).to eq 404
      expect(json["errors"]).to eq "Project not found"
    end

    context "Updating a project" do
      before do
        assign_role!(user, :manager, project)
      end

      it "saves with valid data" do
        params = { format: "json", project: { name: "Lollipop" } }
        patch api_project_path(project, params), {}, headers

        json_response = JSON.parse(response.body)
        expect(response.status).to eq 201
        expect(json_response["project"]["name"]).to eq "Lollipop"

      end
    end
  end

  context "as an authenticated admin" do
    before do
      user.admin!
    end

    let(:headers) do
      { "HTTP_AUTHORIZATION" => "Token token=#{user.api_key}" }
    end

    it "can create a new project" do
      params = { format: "json", project: { name: "V", description: "Maroon 5 album" } }
      post api_projects_path(params), {}, headers

      new_project  = ProjectSerializer.new(Project.last).to_json
      expect(response.body).to eq new_project
    end

    it "cannot create a ticket with invalid data" do
      params = { format: "json", project: { name: "", description: ""} }
      post api_projects_path(params), {}, headers

      expect(response.status).to eq 422
      json = { "errors" => [ "Name can't be blank"] }

      expect(JSON.parse(response.body)).to eq json
    end

    it "can delete a project" do
      delete api_project_path(chrome_project), {}, headers

      expect(response.status).to eq 202

      expect(json["success"]).to eq "Project has been deleted."
    end
  end

end
