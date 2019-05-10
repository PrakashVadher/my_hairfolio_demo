require 'rails_helper'

RSpec.describe Message, type: :model do

  let(:message) { build(:message) }

  it 'should be valid' do
    expect(message).to be_valid
  end
end
