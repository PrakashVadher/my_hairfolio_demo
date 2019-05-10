require 'spec_helper'

describe Api::V1::ServicesController do

  let(:brand) { create(:brand) }
  let(:service_s) { create(:service) }

  before :each do
    brand.services << service_s
    brand.reload
    service_s.reload
  end

  describe "GET #index" do
    it 'should display available services' do
      get :index
      expect(json_response['services'].count).to eq(1)
    end

    it 'should filter by brand available services' do
      get :index, params: { brand_id: brand.id }
      expect(json_response['services'].count).to eq(1)
    end
  end

  describe "GET #show" do

    it 'should display the brand attributes' do
      get :show, params: { id: service_s.id }
      expect(json_response['service']['name']).to eq(service_s.name)
    end
  end
end
