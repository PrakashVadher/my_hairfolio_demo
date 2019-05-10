require 'rails_helper'

RSpec.describe Notification, type: :model do

  let(:notification) { build(:notification) }

  it 'should be valid' do
    expect(notification).to be_valid
  end

  describe 'should require' do
    it 'a body' do
      notification.body = nil
      expect(notification).to_not be_valid
    end

    it 'a user' do
      notification.user = nil
      expect(notification).to_not be_valid
    end

    it 'a notifiable object' do
      notification.notifiable = nil
      expect(notification).to_not be_valid
    end
  end
end
