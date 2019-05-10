require 'rails_helper'

RSpec.describe Tag, type: :model do

  let(:tag) { build(:tag) }

  it 'should be valid' do
    expect(tag).to be_valid
  end
  describe 'should require ' do
    it 'a name' do
      tag.name = nil
      expect(tag).to_not be_valid
    end
  end
end
