require 'rails_helper'
require 'support/model_attributes'
require 'support/user_sign_in'

RSpec.feature "Search", type: :feature do

  let(:user) { User.create!(user_attributes) }
  let!(:organization) { user.organizations.create!(organization_attributes) }
  let!(:pierre) { organization.members.create!(member_attributes) }
  let!(:amanda) { organization.members
                  .create!(member_attributes(first_name: "Amanda", 
                                             email: "amanda@example.com")) }
  let!(:group) { user.groups.create!(group_attributes) }
  let!(:event) { group.events.create!(event_attributes) }

  context "by signed in user" do
    before { sign_in user }

    before do
      group.members << [pierre, amanda]
      event.members << amanda
    end

    scenario "for organizations in organiations index page" do
      visit organizations_path
      expect(page).to have_text organization.email
      fill_in "organization_search", with: "NNNNNNN"
      click_button "Find Organizations"
      expect(page).not_to have_text organization.email
      fill_in "organization_search", with: organization.email
      click_button "Find Organizations"
      expect(page).to have_text organization.email
    end

    scenario "for members in organization view page" do
      visit organization_path organization
      expect(page).to have_text pierre.email
      fill_in "member_search", with: "NNNNNNN"
      click_button "Find Members"
      expect(page).not_to have_text pierre.email
      fill_in "member_search", with: amanda.email
      click_button "Find Members"
      expect(page).to have_text amanda.first_name
    end

    scenario "in members members index page" do
      visit members_path
      expect(page).to have_text pierre.name
      fill_in "keywords", with: "YYYYYYY"
      click_button "Find Members"
      expect(page).not_to have_text pierre.email
      fill_in "keywords", with: pierre.first_name
      click_button "Find Members"
      expect(page).to have_text pierre.email
    end

    scenario "in groups in groups index page" do
      visit groups_path
      expect(page).to have_text group.name
      fill_in "keywords", with: ">>>>>>"
      click_button "Find Groups"
      expect(page).not_to have_text group.name
      fill_in "keywords", with: group.name
      click_button "Find Groups"
      expect(page).to have_text group.name
    end

    scenario "in events in groups events index page" do
      visit group_events_path group
      expect(page).to have_text event.title
      fill_in "event_search", with: "NNNNNNN"
      click_button "Find Events"
      expect(page).not_to have_text event.title
      fill_in "event_search", with: event.title
      click_button "Find Events"
      expect(page).to have_text event.title
    end

    scenario "in members in events registrations index page" do
      visit event_registrations_path event
      expect(page).to have_text pierre.first_name
      fill_in "member_search", with: "YYYYYYY"
      click_button "Find Members"
      expect(page).not_to have_text pierre.email
      fill_in "member_search", with: pierre.first_name
      click_button "Find Members"
      expect(page).to have_text pierre.email
    end

    scenario "in registrations in events registrations index page" do
      visit event_registrations_path event
      expect(page).to have_text amanda.first_name
      fill_in "registration_search", with: "YYYYYYY"
      click_button "Find Registrations"
      expect(page).not_to have_text amanda.email
      fill_in "registration_search", with: amanda.first_name
      click_button "Find Registrations"
      expect(page).to have_text amanda.email
    end

    scenario "in event in events index page" do
      visit events_path
      expect(page).to have_text event.title
      fill_in "event_search", with: "NNNNNNN"
      click_button "Find Events"
      expect(page).not_to have_text event.title
      fill_in "event_search", with: event.title
      click_button "Find Events"
      expect(page).to have_text event.title
    end

  end
end
  
