require 'rails_helper'

RSpec.describe Category, type: :model do

  let(:category) { build(:category)}

  it 'should be valid' do
    expect(category).to be_valid
  end

  describe 'should require' do
    it 'a name' do
      category.name = nil
      expect(category).to_not be_valid
    end
  end
end
