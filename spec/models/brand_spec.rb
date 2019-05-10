require 'spec_helper'

RSpec.describe Brand, type: :model do

  let(:brand) { build(:brand)}

  it 'should be valid' do
    expect(brand).to be_valid
  end

  describe 'should require' do
    it 'a name' do
      brand.name = nil
      expect(brand).to_not be_valid
    end
  end
end
