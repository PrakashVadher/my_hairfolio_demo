require 'spec_helper'

describe Api::V1::ConversationsController do

  let(:user) { create(:user) }

  before :each do
    api_authorization_header(user.auth_token)
  end

  describe "GET #index" do

    it 'should display current user conversations' do
      conversation = create(:conversation, sender: user)
      get :index
      expect(json_response['conversations'].count).to eq(1)
      expect(json_response['conversations'].first['last_message']['body']).to eq(conversation.messages.last.body)
    end
  end

  describe "POST #read" do

    it 'should mark conversation messages as read' do
      conversation = create(:conversation, sender: user)
      message = create(:message, conversation: conversation)
      post :read, params: { id: conversation.id }
      expect(json_response['conversation']['last_message']['read']).to eq(true)
    end
  end

  describe 'POST #create' do
    describe 'with valid fields' do
      it 'should create the contact with a phone and email' do
        conversation_params =  build(:conversation).attributes
        user_2 = create(:user)
        conversation_params['recipient_ids'] = [user_2.id]
        post :create, params: { conversation:  conversation_params }
        expect(json_response['conversation']['sender_id']).to eq(conversation_params['sender_id'])
      end
    end

    describe 'with invalid fields' do
      it 'should create the contact with a phone and email' do
        conversation_params =  build(:conversation).attributes
        user_2 = create(:user)
        conversation_params['recipient_ids'] = [user_2.id]
        conversation_params['sender_id'] = nil
        post :create, params: { conversation: conversation_params }
        expect(json_response['errors']['sender']).to include("can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    describe 'with valid fields' do
      it 'should create the contact with a phone and email' do
        conversation = create(:conversation, sender: user)
        user_3 = create(:user)
        patch :update, params: { id: conversation.id, conversation: { recipient_ids: [user_3.id]} }
        expect(json_response['conversation']['recipient_ids']).to eq([user_3.id])
      end
    end

    describe 'with invalid fields' do
      it 'should create the contact with a phone and email' do
        conversation = create(:conversation, sender: user)
        patch :update, params: { id: conversation.id, conversation: { sender_id: ""} }
        expect(json_response['errors']['sender']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete the contact' do
      conversation = create(:conversation, sender: user)
      delete :destroy, params: { id: conversation.id }
      expect(response.status).to eq(204)
    end
  end
end
