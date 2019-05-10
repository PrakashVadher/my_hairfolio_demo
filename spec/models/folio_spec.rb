require 'rails_helper'

RSpec.describe Folio, type: :model do

  let(:folio) { build(:folio)}

  it 'should be valid' do
    expect(folio).to be_valid
  end

  describe 'should require' do
    it 'a name' do
      folio.name = nil
      expect(folio).to_not be_valid
    end

    it 'a user' do
      folio.user = nil
      expect(folio).to_not be_valid
    end
  end
end
