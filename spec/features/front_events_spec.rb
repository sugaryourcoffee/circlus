require 'rails_helper'
require 'support/model_attributes'
require 'support/user_sign_in'

RSpec.feature "Front page event section", type: :feature do

  let(:user) { User.create(user_attributes) }
  let(:organization) { user.organizations.create!(organization_attributes) }
  let(:group) { user.groups.create(group_attributes) }
  let!(:today) { group.events.create!(event_attributes(
                                       title: "Run",
                                       start_date: Date.today )) }
  let!(:thisweek) { group.events.create!(event_attributes(
                                          title: "Walk",
                                          start_date: Date.today + 7)) }
  let!(:thismonth) { group.events.create!(event_attributes(
                                           title: "Stay",
                                           start_date: Date.today + 30)) }

  context "by signed in user" do

    before do
      sign_in user
      visit root_path
    end

    scenario "shows events" do
      expect(page).to have_text "Today"
      expect(page).to have_text today.title
      expect(page).to have_text "Next 7 days"
      expect(page).to have_text thisweek.title
      expect(page).to have_text "Next 30 days"
      expect(page).to have_text thismonth.title
    end

  end
end
 
