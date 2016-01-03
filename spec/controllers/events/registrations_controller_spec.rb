require 'rails_helper'
require 'support/user_sign_in'
require 'support/model_attributes'

RSpec.describe Events::RegistrationsController, type: :controller do

  let(:user) { User.create!(user_attributes) }
  let(:organization) { user.organizations.create!(organization_attributes) }
  let(:member) { organization.members.create!(member_attributes) }
  let(:group) { user.groups.create!(group_attributes) }
  let(:event) { group.events.create!(event_attributes) }

  before do
    group.members << member
    event.members = group.members
    @registration = event.registrations.first
    sign_in user 
  end

  describe "GET #index" do
    it "returns http success" do
      get :index, { event_id: event.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #register" do
    it "returns http redirect" do
      get :destroy, { event_id: event.id, id: @registration.id }
      get :register, { id: event.id, member_id: member.id }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #destroy" do
    it "returns http redirect" do
      get :destroy, { event_id: event.id, id: @registration.id }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #confirm" do
    it "returns http redirect" do
      get :confirm, { event_id: event.id, id: @registration.id }
      expect(response).to have_http_status(:redirect)
    end
  end

end
