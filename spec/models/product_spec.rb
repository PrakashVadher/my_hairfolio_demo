require 'rails_helper'

RSpec.describe Product, type: :model do

  let(:product) { build(:product) }

  it 'should be valid' do
    expect(product).to be_valid
  end
  describe 'should require ' do
    it 'a name' do
      product.name = nil
      expect(product).to_not be_valid
    end

    it 'a tag' do
      product.tag = nil
      expect(product).to_not be_valid
    end
  end
end
