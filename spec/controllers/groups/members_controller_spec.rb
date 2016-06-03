require 'rails_helper'
require 'support/model_attributes'

RSpec.describe Groups::MembersController, type: :controller do

  let(:user) { User.create!(user_attributes) }
  let(:organization) { user.organizations.create!(organization_attributes) }
  let(:member) { organization.members.create!(member_attributes) }
  let(:group) { user.groups.create!(group_attributes) }

  before { sign_in user }

  describe "GET #index" do
    it "returns http success" do
      get :index, { group_id: group.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #add" do
    it "returns http redirect" do
      get :add, { group_id: group.id, id: member.id }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #remove" do
    it "returns http redirect" do
      get :add, { group_id: group.id, id: member.id }
      get :remove, { group_id: group.id, id: member.id }
      expect(response).to have_http_status(:redirect)
    end
  end


end
