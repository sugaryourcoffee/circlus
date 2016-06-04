require 'rails_helper'
require 'support/model_attributes'
require 'support/user_sign_in'
require 'support/member_support'
require 'support/page_helper'

RSpec.feature "Multiple phones", type: :feature do
 
  let(:user) { User.create!(user_attributes) }
  let(:organization) { user.organizations.create!(organization_attributes) }
  let!(:member) { organization.members.create!(member_attributes) }
  let!(:church) { user.groups.create!(group_attributes(name: "Church")) }
  let!(:school) { user.groups.create!(group_attributes(name: "School")) }

  context "by signed in user" do

    before { signin user }

    scenario "will be able to add additional email to new member", js: true do
      click_link "Organizations"
      click_link "View members"
      click_link "Create new member"
      fill_in "First name", with: "Amanda"
      fill_in "Title", with: "Dr."
      fill_in "Date of birth", with: Time.now
      fill_in "Phone", with: "1111111111"
      fill_in "Email", with: "amanda@example.com"
      click_link "Add email"
      select "Private", 
        from: element_of(/member_emails_attributes_\d+_category/).first
      fill_in element_of(/member_emails_attributes_\d+_address/).first, 
        with: "amanda@private.com"
      expect { click_button "Create Member" }.to change(Member, :count).by(1)
    end

    scenario "will be able to edit additional email of member", js: true do
      click_link "Organizations"
      click_link "View members"
      click_link "Edit"
      click_link "Add email"
      select "Business", 
        from: element_of(/member_emails_attributes_\d+_category/).first
      fill_in element_of(/member_emails_attributes_\d+_address/).first, 
        with: "pierre.example@business.com"
      expect { click_button "Update Member" }.to change(Member, :count).by(0)
      click_link "Edit"
      expect(page.current_path)
        .to eq edit_organization_member_path(organization, member)
    end

  end
end
