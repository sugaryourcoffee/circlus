require 'rails_helper'
require 'support/model_attributes'
require 'support/user_sign_in'
require 'support/member_support'

RSpec.feature "Members", type: :feature do
  
  let(:user) { User.create!(user_attributes) }
  let(:organization) { user.organizations.create!(organization_attributes) }

  context "with signed in user" do

    before { sign_in user }

    context "in user's organization" do
      scenario "adds member" do
        visit organization_path organization
        click_link "Create new member"
        fill_in "Title", with: "Dr."
        fill_in "First name", with: "Amanda"
        fill_in "Date of birth", with: "14.02.1971"
        fill_in "Phone", with: "0173 1234567"
        fill_in "Email", with: "amanda@thesugars.de"
        fill_in "Information", with: "Beauty"
        expect { click_button "Create" }.to change(Member, :count).by(1)
        expect(page.current_path).to eq organization_path organization
        expect(page).to have_text "Dr. Amanda"
      end

      scenario "removes member" do
        fill_in_member
        click_button "Create"
        expect { click_link "Delete" }.to change(Member, :count).by(-1)
        expect(page.current_path).to eq organization_path organization
      end

      scenario "edits member" do
        fill_in_member
        click_button "Create"
        click_link "Edit"
        fill_in "Title", with: "Dr. Org."
        click_button "Update"
        expect(page.current_path).to eq organization_path organization
        expect(page).to have_text "Dr. Org. Amanda"
      end

      scenario "cancels edit member" do
        fill_in_member
        click_button "Create"
        click_link "Edit"
        fill_in "Title", with: ""
        expect { click_link "Cancel" }.to change(Member, :count).by(0)
        expect(page.current_path).to eq organization_path organization
        expect(page).to have_text "Dr. Amanda"
      end
    end
  end
end
