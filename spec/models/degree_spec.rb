require 'rails_helper'

RSpec.describe Degree, type: :model do

  let(:degree) { build(:degree)}

  it 'should be valid' do
    expect(degree).to be_valid
  end

  describe 'should require' do
    it 'a name' do
      degree.name = nil
      expect(degree).to_not be_valid
    end
  end
end
