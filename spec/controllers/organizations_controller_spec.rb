require 'rails_helper'
require 'support/model_attributes'

RSpec.describe OrganizationsController, type: :controller do

  let(:user) { User.create!(user_attributes) }
  let(:organization) { user.organizations.create!(organization_attributes) }

  before { sign_in user }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "returns http redirect" do
      post :create, { :organization => organization_attributes }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, { :id => organization.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    it "returns http redirect" do
      put :update, { id: organization.id, 
                     organization: organization_attributes } 
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #destroy" do
    it "returns http redirect" do
      get :destroy, { id: organization.id }
      expect(response).to have_http_status(:redirect)
    end
  end

end
