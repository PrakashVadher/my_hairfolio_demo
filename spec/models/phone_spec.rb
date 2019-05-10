require 'rails_helper'

RSpec.describe Phone, type: :model do

  let(:phone) { build(:phone)}

  it 'should be valid' do
    expect(phone).to be_valid
  end

  describe 'should require' do
    it 'an number' do
      phone.number = nil
      expect(phone).to_not be_valid
    end

    it 'an phone type' do
      phone.phone_type = nil
      expect(phone).to_not be_valid
    end
  end
end
