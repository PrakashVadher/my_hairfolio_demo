require 'spec_helper'

describe Api::V1::TagsController do

  let(:tag) { create(:tag) }
  let(:user) { create(:user) }

  before :each do
    tag.reload
  end

  describe "GET #index" do
    before :each do
      api_authorization_header(user.auth_token)
    end

    it 'should display available tags' do
      get :index
      expect(json_response['tags'].count).to eq(0)
    end

    it 'should filter by tag by query' do
      get :index, params: { q: tag.name }
      expect(json_response['tags'].count).to eq(0)
    end

    it 'should filter by popular by query' do
      tag = create(:tag)
      create(:label, tag: tag)
      get :index, params: { q: tag.name }
      puts response.body
      expect(json_response['tags'].first['name']).to eq(tag.name)
    end
  end

  describe "GET #exact" do
    it 'should filter by tag by query' do
      get :exact, params: { q: tag.name }
      expect(json_response['tag']['name']).to eq(tag.name)
    end
  end

  describe "GET #show" do
    it 'should display tag information' do
      get :show, params: { id: tag.id }
      expect(json_response['tag']['name']).to eq(tag.name)
    end
  end


  describe "POST #create" do
    describe 'with valid fields' do
      it 'should display tag information' do
        post :create, params: { tag: { name: "tajfklsjfd"} }
        expect(json_response['tag']['name']).to eq("tajfklsjfd")
      end
    end

    describe 'with invalid fields' do
      it 'shoudl not reate the tag' do
        post :create, params: { tag: { name: ""} }
        expect(json_response['errors']['name']).to include("can't be blank")
      end
    end
  end

  describe "GET #posts" do
    before :each do
      api_authorization_header(user.auth_token)
    end

    it 'should display available posts for the tags' do
      labels = create_list(:label, 10, tag: tag)
      get :posts, params: { id: tag.id }
      expect(json_response['posts'].count).to eq(8)
    end

  end
end
