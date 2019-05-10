require 'rails_helper'

RSpec.describe Treatment, type: :model do

  let(:treatment) { build(:treatment) }

  it 'should be valid' do
    expect(treatment).to be_valid
  end

  describe 'it should require' do
    it 'a color' do
      treatment.color = nil
      expect(treatment).to_not be_valid
    end

    it 'a weight' do
      treatment.weight = nil
      expect(treatment).to_not be_valid
    end
  end
end
