require 'spec_helper'

describe Api::V1::EducationsController do

  let(:user) { create(:user) }
  let(:education) { create(:education, user: user) }

  before :each do
    api_authorization_header(user.auth_token)
  end

  describe "GET #index" do

    it 'should display user educations' do
      education.save
      get :index, params: { user_id: user.id }
      expect(json_response['educations'].count).to eq(1)
    end
  end

  describe "GET #show" do
    it 'should display the education' do
      education.save
      get :show, params: { user_id: user.id, id: education.id }
      expect(json_response['education']).to_not be_nil
    end
  end

  describe "POST #create" do
    describe 'with valid fields' do
      it 'should create an education' do
        education_params = build(:education).attributes
        post :create, params: { user_id: user.id, education: education_params }
        expect(json_response['education']['name']).to eq(education_params['name'])
      end
    end

    describe 'with invalid fields' do
      it 'should not create a like if already liked' do
        education_params = build(:education).attributes
        education_params['name'] = nil
        post :create, params: { user_id: user.id, education: education_params }
        expect(json_response['errors']['name']).to include("can't be blank")
      end
    end
  end

  describe "PATCH #update" do
    describe 'with valid fields' do
      it 'should update an education' do
        patch :update, params: { user_id: user.id, id: education.id, education: { name: "Howdy"} }
        expect(json_response['education']['name']).to eq("Howdy")
      end
    end

    describe 'with invalid fields' do
      it 'should not create a like if already liked' do
        patch :update, params: { user_id: user.id, id: education.id, education: { name: ""} }
        expect(json_response['errors']['name']).to include("can't be blank")
      end
    end
  end

  describe "DELETE #destroy" do
    it 'should delete a like when found' do
      education.save
      delete :destroy, params: { user_id: user.id, id: education.id }
      expect(response.status).to eq(204)
    end
  end
end
