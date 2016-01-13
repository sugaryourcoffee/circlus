require 'rails_helper'
require 'support/model_attributes'
require 'support/user_sign_in'

RSpec.feature "Front Page Search", type: :feature do

  let(:user) { User.create(user_attributes) }
  let(:organization) { user.organizations.create!(organization_attributes) }
  let!(:today) { organization
                 .members
                 .create!(member_attributes(date_of_birth: Time.now,
                                            first_name: "Jane")) }
  let!(:thisweek) { organization
                    .members
                    .create(member_attributes(date_of_birth: 6.days.from_now,
                                              first_name: "Joe"))}

  let!(:thismonth) { organization
                    .members
                    .create(member_attributes(date_of_birth: 29.days.from_now,
                                              first_name: "Mack"))}

  context "by signed in user" do

    before do
      sign_in user
      visit root_path
    end

    scenario "shows birthdays" do
      expect(page).to have_text "Today"
      expect(page).to have_text today.first_name
      expect(page).to have_text "Next 7 days"
      expect(page).to have_text thisweek.first_name
      expect(page).to have_text "Next 30 days"
      expect(page).to have_text thismonth.first_name
    end

  end
end
 
