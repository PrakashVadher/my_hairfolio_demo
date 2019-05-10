require 'rails_helper'

RSpec.describe Conversation, type: :model do

  let(:conversation) { build(:conversation) }

  it 'should be valid' do
    expect(conversation).to be_valid
  end

  describe 'should require' do
    it 'a sender' do
      conversation.sender = nil
      expect(conversation).to_not be_valid
    end
  end
end
