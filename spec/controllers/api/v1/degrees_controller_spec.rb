require 'spec_helper'

describe Api::V1::DegreesController do

  describe "GET #index" do

    it 'should display available brands and services' do
      degree = create(:degree)
      get :index
      expect(json_response['degrees'].count).to eq(1)
    end
  end

  describe "GET #show" do

    it 'should display the brand attributes' do
      degree = create(:degree)
      get :show, params: { id: degree.id }
      expect(json_response['degree']['name']).to eq(degree.name)
    end
  end
end
