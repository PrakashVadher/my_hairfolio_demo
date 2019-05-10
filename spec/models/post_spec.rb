require 'rails_helper'

RSpec.describe Post, type: :model do

  let(:post) { build(:post) }

  it 'should be valid' do
    expect(post).to be_valid
  end

  describe 'should require' do
    it 'a description' do
      post.description = nil
      expect(post).to_not be_valid
    end

    it 'a user' do
      post.user = nil
      expect(post).to_not be_valid
    end
  end
end
