require 'rails_helper'

RSpec.describe Color, type: :model do

  let(:color) { build(:color)}

  it 'should be valid' do
    expect(color).to be_valid
  end

  describe 'should require' do
    it 'a code' do
      color.code = nil
      expect(color).to_not be_valid
    end

    it 'a start hex' do
      color.start_hex = nil
      expect(color).to_not be_valid
    end

    it 'an end hex' do
      color.end_hex = nil
      expect(color).to_not be_valid
    end
  end
end
