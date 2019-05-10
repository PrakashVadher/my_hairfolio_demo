require 'rails_helper'

RSpec.describe Line, type: :model do

  let(:line) { build(:line)}

  it 'should be valid' do
    expect(line).to be_valid
  end

  describe 'should require' do
    it 'a name' do
      line.name = nil
      expect(line).to_not be_valid
    end

    it 'a unit' do
      line.unit = nil
      expect(line).to_not be_valid
    end

    it 'a brand' do
      line.brand = nil
      expect(line).to_not be_valid
    end
  end
end
