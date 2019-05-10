require 'spec_helper'

describe Api::V1::ProductsController do

  let(:product) { create(:product) }

  before :each do
    product.reload
  end

  describe "GET #index" do
    it 'should display available products' do
      get :index
      expect(json_response['products'].count).to eq(1)
    end

    it 'should filter by products by query' do
      get :index, params: { q: product.name }
      expect(json_response['products'].count).to eq(1)
    end
  end
end
