require 'spec_helper'

describe Api::V1::CertificatesController do

  describe "GET #index" do

    it 'should display available brands and services' do
      certificate = create(:certificate)
      get :index
      expect(json_response['certificates'].count).to eq(1)
    end
  end

  describe "GET #show" do

    it 'should display the brand attributes' do
      certificate = create(:certificate)
      get :show, params: { id: certificate.id }
      expect(json_response['certificate']['name']).to eq(certificate.name)
    end
  end
end
