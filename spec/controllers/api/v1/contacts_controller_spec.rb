require 'spec_helper'

describe Api::V1::ContactsController do

  let(:user) { create(:user) }

  before :each do
    api_authorization_header(user.auth_token)
  end

  describe "GET #index" do

    it 'should display current user contacts' do
      contact = create(:contact, user: user)
      get :index
      expect(json_response['contacts'].count).to eq(1)
    end
  end

  describe "GET #show" do

    it 'should display the contact information' do
      contact = create(:contact, user: user)
      get :show, params: { id: contact.id }
      expect(json_response['contact']['first_name']).to eq(contact.first_name)
      expect(json_response['contact']['emails'].first['email']).to eq(contact.emails.first.email)
    end
  end

  describe 'POST #create' do
    describe 'with valid fields' do
      it 'should create the contact with a phone and email' do
        contact_params =  build(:contact).attributes
        contact_params['emails_attributes'] = build(:email).attributes
        contact_params['phones_attributes'] = build(:phone).attributes
        post :create, params: { contact:  contact_params }
        expect(json_response['contact']['first_name']).to eq(contact_params['first_name'])
        expect(json_response['contact']['emails'].count).to eq(1)
        expect(json_response['contact']['phones'].count).to eq(1)
      end
    end

    describe 'with invalid fields' do
      it 'should create the contact with a phone and email' do
        contact_params = { first_name: ""}
        contact_params['emails_attributes'] = build(:email).attributes
        contact_params['phones_attributes'] = build(:phone).attributes
        post :create, params: { contact: contact_params }
        expect(json_response['errors']['first_name']).to include("can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    describe 'with valid fields' do
      it 'should create the contact with a phone and email' do
        contact = create(:contact, user: user)
        patch :update, params: { id: contact.id, contact: { first_name: "New Name"} }
        expect(json_response['contact']['first_name']).to eq("New Name")
      end
    end

    describe 'with invalid fields' do
      it 'should create the contact with a phone and email' do
        contact = create(:contact, user: user)
        patch :update, params: { id: contact.id, contact: { first_name: ""} }
        expect(json_response['errors']['first_name']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete the contact' do
      contact = create(:contact, user: user)
      delete :destroy, params: { id: contact.id }
      expect(response.status).to eq(204)
    end
  end
end
