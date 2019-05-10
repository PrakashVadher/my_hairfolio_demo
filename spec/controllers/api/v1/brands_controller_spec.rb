require 'spec_helper'

describe Api::V1::BrandsController do

  describe "GET #index" do

    it 'should display available brands and services' do
      brand = create(:brand)
      service = create(:service)
      brand.services << service
      get :index
      expect(json_response['brands'].count).to eq(1)
    end
  end

  describe "GET #show" do

    it 'should display the brand attributes' do
      brand = create(:brand)
      get :show, params: { id: brand.id }
      expect(json_response['brand']['name']).to eq(brand.name)
    end
  end
end
