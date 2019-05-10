require 'spec_helper'

RSpec.describe Authentication, type: :model do

  let(:authentication) { build(:authentication) }

  it 'should be valid' do
    expect(authentication).to be_valid
  end

  describe 'should require' do
    it 'a user' do
      authentication.user = nil
      expect(authentication).to_not be_valid
    end

    it 'a provider' do
      authentication.provider = nil
      expect(authentication).to_not be_valid
    end
  end
end
