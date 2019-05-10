require 'rails_helper'

RSpec.describe Provider, type: :model do

  let(:provider) { build(:provider) }

  it 'should be valid' do
    expect(provider).to be_valid
  end

  describe 'should require' do
    it 'a name' do
      provider.name = nil
      expect(provider).to_not be_valid
    end
  end
end
