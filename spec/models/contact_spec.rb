require 'rails_helper'

RSpec.describe Contact, type: :model do

  let(:contact) { build(:contact)}

  it 'should be valid' do
    expect(contact).to be_valid
  end

  describe 'should require' do
    it 'a first name' do
      contact.first_name = nil
      expect(contact).to_not be_valid
    end
  end
end
