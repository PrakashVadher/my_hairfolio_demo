require 'spec_helper'

describe Api::V1::ExperiencesController do

  describe "GET #index" do

    it 'should display available brands and services' do
      experience = create(:experience)
      get :index
      expect(json_response['experiences'].count).to eq(1)
    end
  end
end
