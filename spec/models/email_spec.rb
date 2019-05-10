require 'rails_helper'

RSpec.describe Email, type: :model do

  let(:email) { build(:email)}

  it 'should be valid' do
    expect(email).to be_valid
  end

  describe 'should require' do
    it 'an email' do
      email.email = nil
      expect(email).to_not be_valid
    end

    it 'an email type' do
      email.email_type = nil
      expect(email).to_not be_valid
    end
  end
end
