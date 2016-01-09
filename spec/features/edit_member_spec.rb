require 'rails_helper'
require 'support/model_attributes'
require 'support/user_sign_in'
require 'support/member_support'

RSpec.feature "Edit members", type: :feature do
 
  let(:user) { User.create!(user_attributes) }
  let(:organization) { user.organizations.create!(organization_attributes) }
  let!(:member) { organization.members.create!(member_attributes) }
  let!(:church) { user.groups.create!(group_attributes(name: "Church")) }
  let!(:school) { user.groups.create!(group_attributes(name: "School")) }

  context "by signed in user" do

    before { sign_in user }

    scenario "will be able to create members" do
      click_link "Organizations"
      click_link "View members"
      click_link "Create new member"
      fill_in "First name", with: "Amanda"
      fill_in "Title", with: "Dr."
      fill_in "Date of birth", with: Time.now
      fill_in "Phone", with: "1111111111"
      fill_in "Email", with: "amanda@example.com"
      fill_in "Information", with: "Beauty"
      check "group_#{church.id}"
      check "group_#{school.id}"
      expect { click_button "Create Member" }.to change(Member, :count).by(1)
      expect(Member.last.groups).to match [church, school]
    end

    scenario "will be able to edit members" do
      click_link "Organizations"
      click_link "View members"
      click_link "Edit"
      check "group_#{church.id}"
      expect { click_button "Update Member" }.to change(Member, :count).by(0)
      expect(Member.last.groups).to match [church]
    end

  end

end
