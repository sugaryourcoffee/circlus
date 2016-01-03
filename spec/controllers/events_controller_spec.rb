require 'rails_helper'
require 'support/user_sign_in'
require 'support/model_attributes'

RSpec.describe EventsController, type: :controller do

  let(:user) { User.create!(user_attributes) }
  let(:group) { user.groups.create!(group_attributes) }
  let(:event) { group.events.create!(event_attributes) }

  before { sign_in user }

  describe "GET #index" do
    it "returns http success" do
      get :index, { group_id: group.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, { group_id: group.id, id: event.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "renders template new" do
      get :new, { group_id: group.id }
      expect(response).to render_template(:new)
    end

    it "returns http success" do
      get :new, { group_id: group.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "returns http redirect" do
      post :create, { event: event_attributes, 
                      group_id: group.id }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, { :id => event.id, group_id: group.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    it "returns http redirect" do
      put :update, { id: event.id, 
                     event: event_attributes,
                     group_id: group.id } 
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #destroy" do
    it "returns http redirect" do
      get :destroy, { id: event.id, group_id: group.id }
      expect(response).to have_http_status(:redirect)
    end
  end

end
