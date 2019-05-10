require 'rails_helper'

RSpec.describe Certificate, type: :model do

  let(:certificate) { build(:certificate)}

  it 'should be valid' do
    expect(certificate).to be_valid
  end

  describe 'should require' do
    it 'a name' do
      certificate.name = nil
      expect(certificate).to_not be_valid
    end
  end
end
