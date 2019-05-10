require 'spec_helper'

RSpec.describe Block, type: :model do
  let(:block) { build(:block) }

  it 'should be valid' do
    expect(block).to be_valid
  end

  describe 'it should require' do
    it 'a blocker' do
      block.blocker = nil
      expect(block).to_not be_valid
    end

    it 'a blocking' do
      block.blocking = nil
      expect(block).to_not be_valid
    end
  end
end
