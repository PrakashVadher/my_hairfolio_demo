require 'rails_helper'

RSpec.describe Video, type: :model do

  let(:video) { build(:video)}

  it 'should be valid' do
    expect(video).to be_valid
  end

  describe 'should require' do
    it 'an asset url' do
      video.asset_url = nil
      expect(video).to_not be_valid
    end
  end
end
