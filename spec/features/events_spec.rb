require 'rails_helper'
require 'support/model_attributes'
require 'support/event_support'
require 'support/user_sign_in'

RSpec.feature "Events", type: :feature do
  
  let(:user) { User.create!(user_attributes) }
  let!(:group) { user.groups.create!(group_attributes) }

  context "signed in user" do
    before { signin user }

    scenario "visits the events page" do
      visit groups_path
      expect(page).to have_text group.name
      click_link "View events..."
      expect(page.current_path).to eq group_events_path group
      expect(page).to have_text "Event Search"
    end

    scenario "creates event" do
      visit groups_path
      click_link "View events..."
      click_link "Create new event"
      fill_in "Title", with: "Hackatron"
      fill_in "Description", with: "Hackatron event"
      fill_in "Cost", with: 1
      fill_in "Information", with: "BYOD"
      fill_in "Departure place", with: "Bus station"
      fill_in "Arrival place", with: "Train station"
      fill_in "Venue", with: "Sheraton"
      fill_in "Start date", with: "2016-01-02"
      fill_in "Start time", with: "6:00"
      fill_in "End date", with: "2016-01-03"
      fill_in "End time", with: "18:00"
      expect { click_button "Create" }.to change(Event, :count).by(1)
      expect(page.current_path).to eq group_events_path group
      expect(page).to have_text "Hackatron event"
    end

    scenario "updates event" do
      fill_in_event
      click_button "Create"
      click_link "Edit"
      fill_in "Title", with: "Hackatron 2"
      click_button "Update"
      expect(Event.last.title).to eq "Hackatron 2"
      expect(page.current_path).to eq group_events_path group
    end

    scenario "cancels update event" do
      fill_in_event
      click_button "Create"
      click_link "Edit"
      fill_in "Title", with: "Hackatron 2"
      expect { click_link "Cancel" }.to change(Event, :count).by(0)
      expect(Event.last.title).to eq "Hackatron"
      expect(page.current_path).to eq group_events_path group
    end

    scenario "deletes event" do
      fill_in_event
      click_button "Create"
      expect { click_link "Delete" }.to change(Event, :count).by(-1)
      expect(page.current_path).to eq group_events_path group
    end

    scenario "shows event" do
      fill_in_event
      click_button "Create"
      expect(page.current_path).to eq group_events_path group
      click_link "Registrations..."
      expect(page.current_path).to eq event_registrations_path Event.last
      expect(page).to have_text "Hackatron"
      expect(page).to have_text "Member Search"
      expect(page).to have_text "Registrations Search"
    end

    scenario "shows all user events" do
      visit root_path
      click_link "Events"
      expect(page.current_path).to eq events_path
    end

    context "manages participants" do

      let(:organization) { user.organizations.create!(organization_attributes) }
      let(:group) { user.groups.create!(group_attributes) }

      before do 
        organization.members.create!(member_attributes)
        group.members << organization.members.first
        group.events.create!(event_attributes)
      end

      scenario "register participant at event" do
        visit root_path
        click_link "Groups"
        expect(page.current_path).to eq groups_path
        click_link "View events..."
        expect(page).to have_text group.events.first.title
        click_link "Registrations..."
        expect(page).to have_text group.events.first.title
        expect(page).not_to have_link "De-Register"
        expect(page).not_to have_link "Waiting list"
        click_link "Register"
        expect(page).to have_link "De-Register"
        expect(page).to have_link "Waiting list"
        click_link "Waiting list"
        expect(page).to have_link "Confirm"
        click_link "De-Register"
        expect(page).not_to have_link "De-Register"
        expect(page).not_to have_link "Confirm"
      end
    end
  end

end
