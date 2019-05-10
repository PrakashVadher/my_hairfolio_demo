require 'spec_helper'

describe Api::V1::SessionsController do

  describe "GET #environment" do
    it 'should render the vars' do
      get :environment
      expect(json_response['facebook_app_id']).to_not be_nil
    end
  end

  describe "POST #create" do

    before(:each) do
      @user = create :user
    end

    context "when the credentials are correct with email" do

      before(:each) do
        credentials = { email: @user.email, password: "testing123" }
        post :create, params: { session: credentials }
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        expect(json_response['user']['auth_token']).to eql @user.auth_token
        expect(json_response['user']['id']).to eq(@user.id)
      end

      it { expect(response.status).to eq(200) }
    end

    context "when the credentials are incorrect" do

      before(:each) do
        credentials = { email: @user.email, password: "invalidpassword" }
        post :create, params: { session: credentials }
      end

      it "returns a json with an error" do
        expect(json_response['errors']).to eql "Invalid username or password"
      end

      it "returns a json with an error when mising email or username" do
        credentials = { password: "invalidpassword" }
        post :create, params: { session: credentials }
        expect(json_response['errors']).to eql "Invalid username or password"
      end

      it { expect(response.status).to eq(422) }
    end

  end

  describe "DELETE #destroy" do
    context 'when the user is found' do

      before(:each) do
        user = create :user
        delete :destroy, params: { id: user.auth_token }
      end

      it { expect(response.status).to eq(204) }

    end

    context 'when the user is not found' do

      before(:each) do
        delete :destroy, params: { id: 'fjhsdk' }
      end

      it { expect(response.status).to eq(404) }

    end

  end

  describe "POST #facebook" do

    before :each do
      create(:provider, name: 'facebook')
    end

    context "when the user does not exist" do

      context "when the token is invalid" do

        before :each do
          token = 'badtoken'
          post :facebook, params: { facebook_token: token }
        end

        it 'returns a json with an error' do
          expect(json_response['errors']).to eql "Invalid facebook token"
        end

        it { expect(response.status).to eq(422) }
      end

      context "when the user is not valid" do

        before :each do
          stub_request(:get, "https://graph.facebook.com/me?access_token=baduser&fields=id,name,first_name,last_name,email,friends").to_return(:status => 200, :body => "{}", :headers => {})
          token = 'baduser'
          post :facebook, params: { facebook_token: token }
        end

        it 'returns a json with an error' do
          expect(json_response['errors']).to eql "Invalid user"
        end

        it { expect(response.status).to eq(422) }
      end

      context "when the token is valid" do
        before :each do
          token = 'goodtoken'
          post :facebook, params: { facebook_token: token }
        end

        it 'should return the new user with auth token' do
          expect(json_response['user']['email']).to eq('thebestemail@gmail.com')
        end

        it { expect(response.status).to eq(200) }

      end
    end

    context "when the user already exists" do

      let(:user) { create(:user) }

      before(:each) do
       stub_request(:get, "https://graph.facebook.com/me?access_token=goodtokenemail&fields=id,name,first_name,last_name,email,friends").to_return(:status => 200, :body => "{\"id\":\"904260\",\"bio\":\"I should put something here.\",\"birthday\":\"01/01/1967\",\"email\":\"#{user.email}\",\"first_name\":\"Test\",\"gender\":\"male\",\"last_name\":\"User\",\"link\":\"http://www.facebook.com/839203\",\"locale\":\"en_GB\",\"name\":\"Test User\",\"timezone\":-7,\"updated_time\":\"2015-06-05T20:24:58+0000\",\"verified\":true}", :headers => {})
       token = 'goodtokenemail'
       post :facebook, params: { facebook_token: token }
      end

      context 'when the authentication already exists' do

        it 'should not create a new authentication' do
          token = 'goodtokenemail'
          expect { post :facebook, params: { facebook_token: token } }.to change{ Authentication.count }.by(0)
        end
      end

      context "when the token is valid" do

        it 'should return the new user with auth token' do
          user.reload
          expect(json_response['user']['auth_token']).to eql user.auth_token
        end

        it 'should not create an additional user' do
          expect(User.count).to eq(1)
        end

        it { expect(response.status).to eq(200) }
      end
    end
  end


  describe "POST #instagram" do
    let(:user) { create(:user) }

    before :each do
      create(:provider, name: 'instagram')
    end

    context "when the user does not exist" do

      context "when the token is invalid" do

        before :each do
          token = 'badtoken'
          post :instagram, params: { instagram_token: token }
        end

        it 'returns a json with an error' do
          expect(json_response['errors']).to eql "Invalid instagram token"
        end

        it { expect(response.status).to eq(422) }
      end

      context "when the user is not valid" do

        before :each do
          stub_request(:get, "https://api.instagram.com/v1/users/self.json?access_token=baduser").to_return(:status => 200, :body => "{}", :headers => {})
          token = 'baduser'
          post :instagram, params: { instagram_token: token }
        end

        it 'returns a json with an error' do
          expect(json_response['errors']).to eql "Invalid instagram token"
        end

        it { expect(response.status).to eq(422) }
      end

      context "when the token is valid" do
        before :each do
          token = 'goodtoken'
          post :instagram, params: { instagram_token: token }
        end

        it 'should return the new user with auth token' do
          expect(json_response['user']['email']).to_not be_nil
        end

        it { expect(response.status).to eq(200) }

      end
    end

    context "when the user already exists" do
      before(:each) do
      stub_request(:get, "https://api.instagram.com/v1/users/self.json?access_token=goodtokenemail").to_return(:status => 200, :body => "{\"data\":{\"id\":\"1574083\",\"username\":\"snoopdogg\",\"full_name\":\"Snoop Dogg\",\"profile_picture\":\"http://distillery.s3.amazonaws.com/profiles/profile_1574083_75sq_1295469061.jpg\",\"bio\":\"This is my bio\",\"website\":\"http://snoopdogg.com\",\"counts\":{\"media\":1320,\"follows\":420,\"followed_by\":3410}}}", :headers => {})
       token = 'goodtokenemail'
       post :instagram, params: { instagram_token: token }
      end

      context 'when the authentication already exists' do
        it 'should not create a new authentication' do
          token = 'goodtokenemail'
          expect { post :instagram, params: { instagram_token: token } }.to change{ Authentication.count }.by(0)
        end
      end

      context "when the token is valid" do

        it 'should not create an additional user' do
          expect(User.count).to eq(1)
        end

        it { expect(response.status).to eq(200) }
      end
    end

    context "when the user is signed in" do
      before(:each) do
        stub_request(:get, "https://api.instagram.com/v1/users/self.json?access_token=goodtokenemail").to_return(:status => 200, :body => "{\"data\":{\"id\":\"1574083\",\"username\":\"snoopdogg\",\"full_name\":\"Snoop Dogg\",\"profile_picture\":\"http://distillery.s3.amazonaws.com/profiles/profile_1574083_75sq_1295469061.jpg\",\"bio\":\"This is my bio\",\"website\":\"http://snoopdogg.com\",\"counts\":{\"media\":1320,\"follows\":420,\"followed_by\":3410}}}", :headers => {})
      end

      it 'should add the authentication to their profile' do
        api_authorization_header(user.auth_token)
        expect { post :instagram, params: { instagram_token: 'goodtokenemail' } }.to change{ User.count }.by(0)
      end
    end
  end

  describe 'POST #recover' do
    context 'when the user is found via email' do
      let(:user) { create(:user) }

      it 'returns a success message' do
        post :recover, params: { email: user.email }
        expect(json_response["message"]).to eq("Password email resent")
      end

      it 'sends an email to the user with their password' do
        post :recover, params: { email: user.email }
        expect(ActionMailer::Base.deliveries.last.body).to include("Someone has requested a link to change your password.")
      end
    end

    context 'when the user is not found' do
      it 'returns an error message' do
        post :recover, params: { email: "jfkldsjfd@jklfsd.com" }
        expect(json_response["errors"]).to eq("User not found")
      end

      it 'does not send a reset email' do
        count = ActionMailer::Base.deliveries.count
        post :recover, params: { email: "jfkldsjfd@jklfsd.com" }
        new_count = ActionMailer::Base.deliveries.count
        expect(new_count).to eq(count)
      end
    end
  end

end
