require 'rails_helper'
require 'support/model_attributes'

RSpec.describe GroupsController, type: :controller do

  let(:user) { User.create!(user_attributes) }
  let(:group) { user.groups.create!(group_attributes) }

  before { sign_in user }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, { id: group.id }
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
      post :create, { :group => group_attributes }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, { :id => group.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    it "returns http redirect" do
      put :update, { id: group.id, 
                     organization: group_attributes } 
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #destroy" do
    it "returns http redirect" do
      get :destroy, { id: group.id }
      expect(response).to have_http_status(:redirect)
    end
  end

end
