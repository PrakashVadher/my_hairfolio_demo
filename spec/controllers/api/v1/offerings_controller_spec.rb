require 'spec_helper'

describe Api::V1::OfferingsController do

  let(:user) { create(:user) }
  let(:offering) { create(:offering, user: user) }

  before :each do
    api_authorization_header(user.auth_token)
  end

  describe "GET #index" do

    it 'should display user offerings' do
      offering.save
      get :index, params: { user_id: user.id }
      expect(json_response['offerings'].count).to eq(1)
    end
  end

  describe "GET #show" do

    it 'should display the offering' do
      offering.save
      get :show, params: { user_id: user.id, id: offering.id }
      expect(json_response['offering']).to_not be_nil
    end
  end

  describe "POST #create" do
    describe 'with valid fields' do
      it 'should create an offering' do
        offering_params = build(:offering).attributes
        post :create, params: { user_id: user.id, offering: offering_params }
        expect(json_response['offering']['price']).to eq(offering_params['price'])
      end
    end

    describe 'with invalid fields' do
      it 'should not create a like if already liked' do
        offering_params = build(:offering).attributes
        offering_params['price'] = nil
        post :create, params: { user_id: user.id, offering: offering_params }
        expect(json_response['errors']['price']).to include("can't be blank")
      end
    end
  end

  describe "PATCH #update" do
    describe 'with valid fields' do
      it 'should update an offering' do
        patch :update, params: { user_id: user.id, id: offering.id, offering: { price: 900} }
        expect(json_response['offering']['price']).to eq(900)
      end
    end

    describe 'with invalid fields' do
      it 'should not create a like if already liked' do
        patch :update, params: { user_id: user.id, id: offering.id, offering: { price: ""} }
        expect(json_response['errors']['price']).to include("can't be blank")
      end
    end
  end

  describe "DELETE #destroy" do
    it 'should delete a like when found' do
      offering.save
      delete :destroy, params: { user_id: user.id, id: offering.id }
      expect(response.status).to eq(204)
    end
  end
end
