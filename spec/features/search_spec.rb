require 'rails_helper'
require 'support/model_attributes'
require 'support/user_sign_in'

RSpec.feature "Search", type: :feature do

  let(:user) { User.create!(user_attributes) }
  let!(:organization) { user.organizations.create!(organization_attributes) }
  let!(:member) { organization.members.create!(member_attributes) }
  let!(:group) { user.groups.create!(group_attributes) }
  let!(:event) { group.events.create!(event_attributes) }

  context "by signed in user" do
    before { sign_in user }

    before do
      group.members << member
      event.members << group.members
    end

    scenario "for organizations in organiations index page" do
    end

    scenario "for members in organization view page" do
    end

    scenario "in members members index page" do
    end

    scenario "in groups in groups index page" do
    end

    scenario "in events in groups events index page" do
    end

    scenario "in members in events registrations index page" do
    end

    scenario "in registrations in events registrations index page" do
    end

    scenario "in event in events index page" do
    end

  end
end
  
