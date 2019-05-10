require 'spec_helper'

describe Api::V1::CategoriesController do

  let(:category) { create(:category) }

  before :each do
    category.reload
  end

  describe "GET #index" do
    it 'should display available categories' do
      get :index
      expect(json_response['categories'].count).to eq(1)
    end
  end
end
