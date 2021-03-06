require 'rails_helper'
require 'support/model_attributes'
require 'support/group_support'
require 'support/user_sign_in'

RSpec.feature "Groups", type: :feature do
  
  let(:user) { User.create!(user_attributes) }

  context "signed in user" do
    before { signin user }

    scenario "creates group" do
      visit groups_path
      click_link "Create new group"
      fill_in "Name", with: "Developers"
      fill_in "Website", with: "http://sugaryourcoffee.de/developers"
      fill_in "Description", with: "Description about group developers"
      expect { click_button "Create" }.to change(Group, :count).by(1)
      expect(page.current_path).to eq groups_path
      expect(page).to have_text "Description about group developers"
    end

    scenario "updates group" do
      fill_in_group
      click_button "Create"
      click_link "Edit"
      fill_in "Name", with: "Developers 2"
      click_button "Update"
      expect(Group.last.name).to eq "Developers 2"
      expect(page.current_path).to eq groups_path
    end

    scenario "cancels update group" do
      fill_in_group
      click_button "Create"
      click_link "Edit"
      fill_in "Name", with: "Developers 2"
      expect { click_link "Cancel" }.to change(Group, :count).by(0)
      expect(Group.last.name).to eq "Developers"
      expect(page.current_path).to eq groups_path
    end

    scenario "deletes group" do
      fill_in_group
      click_button "Create"
      expect { click_link "Delete" }.to change(Group, :count).by(-1)
      expect(page.current_path).to eq groups_path
    end

    scenario "shows group" do
      fill_in_group
      click_button "Create"
      expect(page.current_path).to eq groups_path
      click_link "View members..."
      expect(page.current_path).to eq group_path Group.last
      expect(page).to have_text "Developers"
      expect(page).to have_text "Member Search"
      expect(page).to have_link "Add new member"
    end

    scenario "access groups from home page" do
      visit root_path
      click_link "Groups"
      expect(page.current_path).to eq groups_path
    end

    scenario "access events from home page" do

    end

    context "manges group members" do

      let(:organization) { user.organizations.create!(organization_attributes) }

      before do 
        organization.members.create!(member_attributes)
        user.groups.create!(group_attributes)
      end

      scenario "add member to group" do
        visit root_path
        click_link "Groups"
        expect(page.current_path).to eq groups_path
        click_link "View members..."
        expect(page).not_to have_text organization.members.first.first_name
        click_link "Add new member"
        expect(page).to have_text organization.members.first.first_name
        click_link "Add"
        click_link "Back"
        expect(page).to have_text organization.members.first.first_name
      end

      scenario "remove member from group" do
        visit root_path
        click_link "Groups"
        expect(page.current_path).to eq groups_path
        click_link "View members..."
        expect(page).not_to have_text organization.members.first.first_name
        click_link "Add new member"
        expect(page).to have_text organization.members.first.first_name
        click_link "Add"
        click_link "Back"
        expect(page).to have_text organization.members.first.first_name
        click_link "Add new member"
        click_link "Remove"
        click_link "Back"
        expect(page).not_to have_text organization.members.first.first_name
      end
    end
    
  end
end
