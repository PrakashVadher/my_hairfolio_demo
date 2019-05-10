require 'spec_helper'

describe Api::V1::LinesController do

  let(:line) { create(:line) }

  before :each do
    line.reload
  end

  describe "GET #index" do
    it 'should display available lines' do
      get :index
      expect(json_response['lines'].count).to eq(1)
    end

    it 'should filter by brand id' do
      get :index, params: { brand_id: line.brand_id }
      expect(json_response['lines'].count).to eq(1)
    end
  end
end
