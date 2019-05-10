require 'spec_helper'

describe Api::V1::HomeController do

  describe "GET #index" do

    it 'should display the welcome message' do
      get :index
      expect(json_response['message']).to eq('Welcome!')
    end
  end
end
