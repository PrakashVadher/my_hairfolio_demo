require 'rails_helper'

RSpec.describe Experience, type: :model do

  let(:experience) { build(:experience)}

  it 'should be valid' do
    expect(experience).to be_valid
  end

  describe 'should require' do
    it 'a name' do
      experience.name = nil
      expect(experience).to_not be_valid
    end
  end
end
