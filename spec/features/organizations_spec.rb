require 'rails_helper'
require 'support/model_attributes'
require 'support/user_sign_in'

RSpec.feature "Organization", type: :feature do
  
  let(:user) { User.create!(user_attributes) }

  context "signed in user" do
    before { sign_in user }

    scenario "creates organization" do
      visit organizations_path
      click_link "Create new organization"
      fill_in "Name", with: "Sugar Your Coffee"
      fill_in "Street", with: "Sugar Street 52"
      fill_in "Zip", with: "12345"
      fill_in "Town", with: "Sugar Town"
      fill_in "Country", with: "Germany"
      fill_in "Email", with: "sugar@sugaryourcoffee.de"
      fill_in "Website", with: "http://sugaryourcoffee.de"
      fill_in "Information", with: "Information about Sugar Your Coffee"
      expect { click_button "Create" }.to change(Organization, :count).by(1)
      expect(page.current_path).to eq organizations_path
      expect(page).to have_text "Information about Sugar Your Coffee"
    end
  end
end
