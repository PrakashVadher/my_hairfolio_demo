require 'rails_helper'

RSpec.describe Harmony, type: :model do

  let(:harmony) { build(:harmony)}

  it 'should be valid' do
    expect(harmony).to be_valid
  end

  describe 'should require' do
    it 'a name' do
      harmony.name = nil
      expect(harmony).to_not be_valid
    end

    it 'a line' do
      harmony.line = nil
      expect(harmony).to_not be_valid
    end
  end
end
