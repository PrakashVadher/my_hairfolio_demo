require 'rails_helper'

RSpec.describe Salon, type: :model do

  let(:salon) { build(:salon) }

  it 'should be valid' do
    expect(salon).to be_valid
  end
  describe 'should require ' do
    it 'a name' do
      salon.name = nil
      expect(salon).to_not be_valid
    end
  end
end
