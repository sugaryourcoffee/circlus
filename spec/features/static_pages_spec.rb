require 'rails_helper'
require 'support/user_attributes'

RSpec.feature "StaticPages", type: :feature do
  
  let(:user) { User.create!(user_attributes) }

  context "registered user" do

    scenario "calls the home page and signs in" do
      visit root_path
      expect(page).to have_text("Welcome to Circlus")

      click_link "Help"
      expect(page).to have_text("Help")

      click_link "Sign in"
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
      expect(page).to have_text("Contacts of #{user.email}")
    end

    scenario "signs in and signs out" do
    end
  end
end
