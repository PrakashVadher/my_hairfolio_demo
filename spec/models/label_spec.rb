require 'rails_helper'

RSpec.describe Label, type: :model do

  let(:label) { build(:label)}

  it 'should be valid' do
    expect(label).to be_valid
  end

  describe 'should require' do

    it 'a top position' do
      label.position_top = nil
      expect(label).to_not be_valid
    end

    it 'a left position' do
      label.position_left = nil
      expect(label).to_not be_valid
    end
  end
end
