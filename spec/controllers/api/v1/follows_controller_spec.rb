require 'spec_helper'

describe Api::V1::FollowsController do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }

  before :each do
    api_authorization_header(user_1.auth_token)
  end

  describe "GET #index" do

    it 'should shows the user followers' do
      follow = create(:follow, follower: user_2, following: user_1)
      get :index, params: {user_id: user_1.id}
      expect(json_response['users'].count).to eq(1)
    end

    it 'should shows the user followings' do
      follow = create(:follow, follower: user_2, following: user_1)
      get :index, params: {user_id: user_2.id, followings: true }
      expect(json_response['users'].count).to eq(1)
    end

    it 'should shows the user friends' do
      follow = create(:follow, follower: user_2, following: user_1)
      create(:follow, follower: user_1, following: user_2)
      get :index, params: {user_id: user_2.id, friends: true }
      expect(json_response['users'].count).to eq(1)
    end
  end

  describe "POST #create" do
    describe 'with valid fields' do
      it 'should follow the user' do
        post :create, params: { user_id: user_2.id }
        expect(json_response['users'].count).to eq(1)
      end
    end

    describe 'with invalid fields' do
      it 'should not follow the user' do
        follow = create(:follow, follower: user_1, following: user_2)
        post :create, params: { user_id: 279879 }
        expect(json_response['error']).to include("Couldn't find User")
      end
    end
  end

  describe "DELETE #destroy" do
    describe 'with valid fields' do
      it 'should unfollow the user' do
        follow = create(:follow, follower: user_1, following: user_2)
        delete :destroy, params: { user_id: user_2.id }
        expect(response.status).to eq(204)
      end
    end

    describe 'with invalid fields' do
      it 'should not unfollow the user' do
        delete :destroy, params: { user_id: user_2.id }
        expect(response.status).to eq(404)
      end
    end
  end
end
