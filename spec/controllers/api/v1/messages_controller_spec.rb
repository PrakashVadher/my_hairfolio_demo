require 'spec_helper'

describe Api::V1::MessagesController do

  let(:user) { create(:user) }
  let(:conversation) { create(:conversation, sender: user)}

  before :each do
    api_authorization_header(user.auth_token)
  end

  describe "GET #index" do

    it 'should display current user conversations' do
      get :index, params: { conversation_id: conversation.id }
      expect(json_response['messages'].count).to eq(1)
      expect(json_response['messages'].first['body']).to eq(conversation.messages.last.body)
    end
  end

  describe "GET #show" do

    it 'should display the conversation messages' do
      get :show, params: { conversation_id: conversation.id, id: conversation.messages.last.id }
      expect(json_response['message']['body']).to eq(conversation.messages.last.body)
    end
  end

  describe "GET #show" do

    it 'should display the conversation messages' do
      get :show, params: { conversation_id: conversation.id, id: conversation.messages.last.id }
      expect(json_response['message']['body']).to eq(conversation.messages.last.body)
    end
  end

  describe 'POST #create' do
    describe 'with valid fields' do
      it 'should create the contact with a phone and email' do
        message_params =  build(:message).attributes
        post :create, params: { conversation_id: conversation.id, message: message_params }
        expect(json_response['message']['body']).to eq(message_params['body'])
      end
    end
  end

  describe 'PATCH #update' do
    describe 'with valid fields' do
      it 'should create the message' do
        message = create(:message, conversation: conversation)
        patch :update, params: { conversation_id: conversation.id, id: message.id, message: { body: "New Body" } }
        expect(json_response['message']['body']).to eq("New Body")
      end
    end
  end

  describe 'POST #read' do
    it 'should create the contact with a phone and email' do
      message = create(:message, conversation: conversation)
      post :read, params: { conversation_id: conversation.id, id: message.id }
      expect(json_response['message']['read']).to eq(true)
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete the contact' do
      message = create(:message, conversation: conversation)
      delete :destroy, params: { conversation_id: conversation.id, id: message.id }
      expect(response.status).to eq(204)
    end
  end
end
