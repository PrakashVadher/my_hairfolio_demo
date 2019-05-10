require 'spec_helper'

describe Api::V1::PhotosController do

  let(:user) { create(:user) }
  let(:photo) { create(:photo) }

  before :each do
    api_authorization_header(user.auth_token)
  end

  describe "PATCH #update" do
    describe 'with valid fields' do
      it 'should update a photo' do
        patch :update, params: { id: photo.id, photo: { asset_url: "Howdy"} }
        expect(json_response['photo']['asset_url']).to eq("Howdy")
      end
    end

    describe 'with invalid fields' do
      it 'should not update a photo' do
        patch :update, params: { id: photo.id, photo: { asset_url: nil} }
        expect(json_response['errors']['asset_url']).to include("can't be blank")
      end
    end
  end
end
