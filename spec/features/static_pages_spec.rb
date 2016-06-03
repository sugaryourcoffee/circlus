require 'rails_helper'
require 'support/model_attributes'
require 'support/user_sign_in'

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
      expect(page.current_path).to eq organizations_path
      expect(page).to have_text("Organization Search")
    end

    scenario "signs in and signs out" do
      signin user
      expect(page.current_path).to eq organizations_path
      click_link "Sign out"
      expect(page.current_path).to eq root_path
    end
  end
end
