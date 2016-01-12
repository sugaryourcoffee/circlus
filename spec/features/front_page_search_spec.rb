require 'rails_helper'
require 'support/model_attributes'
require 'support/user_sign_in'

RSpec.feature "Front Page Search", type: :feature do

  let(:user) { User.create(user_attributes) }
  let(:organization) { user.organizations.create!(organization_attributes) }
  let!(:member) { organization.members.create!(member_attributes) }

  context "by signed in user" do

    before do
      sign_in user
      visit root_path
    end

    scenario "finds member" do
      fill_in "keywords", with: organization.name
      click_button "Find Members"
      expect(page).to have_text member.email
    end

    scenario "doesn't find member" do
      fill_in "keywords", with: "xxxxxxxx"
      click_button "Find Members"
      expect(page).not_to have_text member.email
    end

  end
end
 
