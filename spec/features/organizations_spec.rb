require 'rails_helper'
require 'support/model_attributes'
require 'support/user_sign_in'
require 'support/organization_support'

RSpec.feature "Organization", type: :feature do
  
  let(:user) { User.create!(user_attributes) }

  context "signed in user" do
    before { signin user }

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

    scenario "updates organization" do
      fill_in_organization
      click_button "Create"
      click_link "Edit"
      fill_in "Name", with: "Sugar Your Coffee 2"
      click_button "Update"
      expect(Organization.last.name).to eq "Sugar Your Coffee 2"
      expect(page.current_path).to eq organizations_path
    end

    scenario "cancels update organization" do
      fill_in_organization
      click_button "Create"
      click_link "Edit"
      fill_in "Name", with: "Sugar Your Coffee 2"
      expect { click_link "Cancel" }.to change(Organization, :count).by(0)
      expect(Organization.last.name).to eq "Sugar Your Coffee"
      expect(page.current_path).to eq organizations_path
    end

    scenario "deletes organization" do
      fill_in_organization
      click_button "Create"
      expect { click_link "Delete" }.to change(Organization, :count).by(-1)
      expect(page.current_path).to eq organizations_path
    end

    scenario "shows organization" do
      fill_in_organization
      click_button "Create"
      expect(page.current_path).to eq organizations_path
      click_link "View members..."
      expect(page.current_path).to eq organization_path Organization.last
      expect(page).to have_text "Sugar Your Coffee"
      expect(page).to have_text "Member Search"
      expect(page).to have_link "Create new member"
    end
  end
end
