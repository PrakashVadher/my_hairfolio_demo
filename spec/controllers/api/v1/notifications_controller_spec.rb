require 'spec_helper'

describe Api::V1::NotificationsController do

  let(:user) { create(:user) }
  let(:postable) { create(:post, user: user) }
  let(:like) { create(:like, post: postable)}
  let(:follow) { create(:follow, following: user)}

  before :each do
    api_authorization_header(user.auth_token)
  end

  describe 'GET #index' do
    it 'should show the current user notifications' do
      follow.save
      like.save
      get :index
      expect(json_response['notifications'].count).to eq(2)
    end


    it 'should show the user follower notifications' do
      user2 = create(:user)
      create(:follow, follower: user2, following: user)
      follow.save
      like.save
      api_authorization_header(user2.auth_token)
      get :index, params: { following: true }
      expect(json_response['notifications'].count).to eq(3)
    end
  end

  describe 'GET #show' do
    it 'should render the notification' do
      follow.save
      get :show, params: { id: user.notifications.last }
      expect(json_response['notification']['user']['id']).to eq(user.id)
    end
  end
end
