require 'spec_helper'

describe Api::V1::SalonsController do

  let(:salon) { create(:salon) }
  let(:user) { create(:user) }

  describe "GET #index" do
    before :each do
      api_authorization_header(user.auth_token)
    end

    it 'should display available salons' do
      salon.reload
      get :index
      expect(json_response['users'].count).to eq(1)
    end

    it 'should display available salons filtered by query' do
      salon.reload
      get :index, params: { q: salon.name }
      expect(json_response['users'].count).to eq(1)
    end
  end

  describe "GET #show" do
    it 'should display the salon attributes' do
      get :show, params: { id: salon.id }
      expect(json_response['salon']['name']).to eq(salon.name)
    end
  end

  describe "GET #stylists" do
    before :each do
      api_authorization_header(user.auth_token)
    end

    it 'should display the salon attributes' do
      create(:user, salon: salon)
      get :stylists, params: { id: salon.id }
      expect(json_response['users'].count).to eq(2)
    end
  end

  describe "POST #create" do
    describe 'with valid fields' do
      it 'should create the salon' do
        salon_attributes = build(:salon).attributes
        post :create, params: { salon: salon_attributes }
        expect(json_response['salon']['name']).to eq(salon_attributes['name'])
      end
    end

    describe 'with invalid fields' do
      it 'should not create the salon' do
        salon_attributes = build(:salon).attributes
        salon_attributes['name'] = ''
        post :create, params: { salon: salon_attributes }
        expect(json_response['errors']['name']).to include("can't be blank")
      end
    end
  end

  describe "PATCH #update" do
    describe 'with valid fields' do
      it 'should update the salon' do
        patch :update, params: { id: salon.id, salon: { name: "New Name"} }
        expect(json_response['salon']['name']).to eq("New Name")
      end
    end

    describe 'with invalid fields' do
      it 'should not update the salon' do
        patch :update, params: { id: salon.id, salon: { name: ""} }
        expect(json_response['errors']['name']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete the salon' do
      delete :destroy, params: { id: salon.id }
      expect(response.status).to eq(204)
    end
  end
end
