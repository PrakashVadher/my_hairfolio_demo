require 'spec_helper'

describe Api::V1::CommentsController do

  let(:user) { create(:user) }
  let(:comment) { create(:comment) }

  before :each do
    api_authorization_header(user.auth_token)
  end

  describe "GET #index" do

    it 'should display current user comments' do
      get :index, params: { post_id: comment.post_id }
      expect(json_response['comments'].count).to eq(1)
    end
  end

  describe 'POST #create' do
    describe 'with valid fields' do
      it 'should create the comment' do
        post :create, params: { post_id: comment.post_id, comment: { body: "ehllo"} }
        expect(json_response['comment']['body']).to eq('ehllo')
        expect(json_response['comment']['user']['id']).to eq(user.id)
      end
    end

    describe 'with invalid fields' do
      it 'should create the contact with a phone and email' do
        post :create, params: { post_id: comment.post_id, comment: { body: ""} }
        expect(json_response['errors']['body']).to include("can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    describe 'with valid fields' do
      it 'should create the contact with a phone and email' do
        patch :update, params: { post_id: comment.post_id, id: comment.id, comment: { body: "New Name"} }
        expect(json_response['comment']['body']).to eq("New Name")
      end
    end

    describe 'with invalid fields' do
      it 'should create the contact with a phone and email' do
        patch :update, params: { post_id: comment.post_id, id: comment.id, comment: { body: ""} }
        expect(json_response['errors']['body']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete the contact' do
      delete :destroy, params: { post_id: comment.post_id, id: comment.id }
      expect(response.status).to eq(204)
    end
  end
end
