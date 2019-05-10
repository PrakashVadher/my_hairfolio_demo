require 'rails_helper'

RSpec.describe Photo, type: :model do

  let(:photo) { build(:photo)}

  it 'should be valid' do
    expect(photo).to be_valid
  end

  describe 'should require' do
    it 'an asset url' do
      photo.asset_url = nil
      expect(photo).to_not be_valid
    end
  end
end
