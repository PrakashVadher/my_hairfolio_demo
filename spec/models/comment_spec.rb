require 'rails_helper'

RSpec.describe Comment, type: :model do

  let(:comment) { build(:comment)}

  it 'should be valid' do
    expect(comment).to be_valid
  end

  describe 'should require' do
    it 'a body' do
      comment.body = nil
      expect(comment).to_not be_valid
    end

    it 'a user' do
      comment.user = nil
      expect(comment).to_not be_valid
    end

    it 'a post' do
      comment.post = nil
      expect(comment).to_not be_valid
    end
  end
end
