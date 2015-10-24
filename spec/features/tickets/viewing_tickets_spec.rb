require "rails_helper"

RSpec.feature "Users can view tickets" do
  before do
    @pringles = create(:project, name: "Pringles")
    create(:ticket, project: @pringles, name: "Make it shiny!", description: "Gradients! Starbursts! Oh my!")

    chrome = create(:project, name: "Google Chrome")
    create(:ticket, project: chrome, name: "Standards compliance", description: "Isn't a joke.")

    visit root_path
  end

  scenario "for a given project" do
    click_link @pringles.name

    expect(page).to have_content "Make it shiny!"
    expect(page).to_not have_content "Standards compliance"

    click_link "Make it shiny!"
    within("#ticket h2") do
      expect(page).to have_content "Make it shiny!"
    end

    expect(page).to have_content "Gradients! Starbursts! Oh my!"
  end
end
