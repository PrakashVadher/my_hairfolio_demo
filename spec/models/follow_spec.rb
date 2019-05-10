require 'rails_helper'

RSpec.describe Follow, type: :model do

  let(:follow) { build(:follow) }

  it 'should be valid' do
    expect(follow).to be_valid
  end

  describe 'it should require' do
    it 'a follower' do
      follow.follower = nil
      expect(follow).to_not be_valid
    end

    it 'a following' do
      follow.following = nil
      expect(follow).to_not be_valid
    end
  end
end
