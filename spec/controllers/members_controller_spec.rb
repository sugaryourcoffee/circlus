require 'rails_helper'
require 'support/model_attributes'

RSpec.describe MembersController, type: :controller do

  let(:user) { User.create!(user_attributes) }
  let(:organization) { user.organizations.create!(organization_attributes) }
  let(:member) { organization.members.create!(member_attributes) }

  before { sign_in user }

  describe "GET #index" do
    it "returns http success" do
      get :index, { organization_id: organization.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "renders template new" do
      get :new, { organization_id: organization.id }
      expect(response).to render_template(:new)
    end

    it "returns http success" do
      get :new, { organization_id: organization.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "returns http redirect" do
      post :create, { member: member_attributes, 
                      organization_id: organization.id }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, { :id => member.id, organization_id: organization.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    it "returns http redirect" do
      put :update, { id: member.id, 
                     member: member_attributes,
                     organization_id: organization.id } 
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #destroy" do
    it "returns http redirect" do
      get :destroy, { id: member.id, organization_id: organization.id }
      expect(response).to have_http_status(:redirect)
    end
  end

end
