require 'rails_helper'

RSpec.describe Like, type: :model do

  let(:like) { build(:like)}

  it 'should be valid' do
    expect(like).to be_valid
  end

  describe 'should require' do
    it 'an user' do
      like.user = nil
      expect(like).to_not be_valid
    end

    it 'a post' do
      like.post = nil
      expect(like).to_not be_valid
    end
  end
end
