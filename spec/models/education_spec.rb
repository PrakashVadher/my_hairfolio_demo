require 'rails_helper'

RSpec.describe Education, type: :model do

  let(:education) { build(:education)}

  it 'should be valid' do
    expect(education).to be_valid
  end

  describe 'should require' do
    it 'a name' do
      education.name = nil
      expect(education).to_not be_valid
    end

    it 'a degree' do
      education.degree = nil
      expect(education).to_not be_valid
    end

    it 'a year from' do
      education.year_from = nil
      expect(education).to_not be_valid
    end

    it 'a year to' do
      education.year_to = nil
      expect(education).to_not be_valid
    end
  end
end
