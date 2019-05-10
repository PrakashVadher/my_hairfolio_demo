require 'spec_helper'

describe Api::V1::BlocksController do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }

  before :each do
    api_authorization_header(user_1.auth_token)
  end

  describe "GET #index" do
    it 'should show the user blocked list' do
      block = create(:block, blocker: user_1, blocking: user_2)
      get :index, params: { user_id: user_1.id }
      expect(json_response['users'].count).to eq(1)
    end
  end

  describe "POST #create" do
    describe 'with valid fields' do
      it 'should block the user' do
        post :create, params: { user_id: user_2.id }
        expect(json_response['users'].count).to eq(1)
      end
    end

    describe 'with invalid fields' do
      it 'should not block the user' do
        post :create, params: { user_id: 279879 }
        expect(json_response['error']).to include("Couldn't find User")
      end
    end

    describe "DELETE #destroy" do
      describe 'with valid fields' do
        it 'should unblock the user' do
          block = create(:block, blocker: user_1, blocking: user_2)
          delete :destroy, params: { user_id: user_2.id }
          expect(response.status).to eq(204)
        end
      end

      describe 'with invalid fields' do
        it 'should not unblock the user' do
          delete :destroy, params: { user_id: user_2.id }
          expect(response.status).to eq(404)
        end
      end
    end
  end
end
