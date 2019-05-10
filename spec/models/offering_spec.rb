require 'rails_helper'

RSpec.describe Offering, type: :model do

  let(:offering) { build(:offering) }

  it 'should be valid' do
    expect(offering).to be_valid
  end

  describe 'it should require' do

    it 'a category' do
      offering.category = nil
      expect(offering).to_not be_valid
    end

    it 'a service' do
      offering.service = nil
      expect(offering).to_not be_valid
    end

    it 'a price' do
      offering.price = nil
      expect(offering).to_not be_valid
    end
  end
end
