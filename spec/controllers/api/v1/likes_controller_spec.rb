require 'spec_helper'

describe Api::V1::LikesController do

  let(:user) { create(:user) }
  let(:postable) { create(:post) }
  let(:like) { create(:like, post: postable, user: user)}

  before :each do
    api_authorization_header(user.auth_token)
  end

  describe "GET #index" do

    it 'should display posts likes' do
      like.save
      get :index, params: { post_id: postable.id }
      expect(json_response['likes'].count).to eq(1)
    end
  end


  describe "POST #create" do
    describe 'with valid fields' do
      it 'should create a like' do
        post :create, params: { post_id: postable.id }
        expect(json_response['like']['post']['id']).to eq(postable.id)
      end
    end

    describe 'with invalid fields' do
      it 'should not create a like if already liked' do
        like.save
        post :create, params: { post_id: postable.id }
        expect(json_response['errors']['post']).to include("has already been taken")
      end
    end
  end

  describe "DELETE #destroy" do
    it 'should delete a like when found' do
      like.save
      delete :destroy, params: { post_id: postable.id }
      expect(response.status).to eq(204)
    end

    it 'should not delete a like when not liked' do
      delete :destroy, params: { post_id: postable.id }
      expect(response.status).to eq(404)
    end
  end
end
