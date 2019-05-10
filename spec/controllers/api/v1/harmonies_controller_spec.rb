require 'spec_helper'

describe Api::V1::HarmoniesController do

  describe "GET #index" do

    it 'should display available brands and services' do
      harmony = create(:harmony)
      color = create(:color, harmony: harmony)
      get :index
      expect(json_response['harmonies'].count).to eq(1)
      expect(json_response['harmonies'].first['colors'].count).to eq(1)
    end

    it 'should filter by line id' do
      harmony = create(:harmony)
      color = create(:color, harmony: harmony)
      get :index, params: { line_id: harmony.line_id }
      expect(json_response['harmonies'].count).to eq(1)
      expect(json_response['harmonies'].first['colors'].count).to eq(1)
    end
  end

end
