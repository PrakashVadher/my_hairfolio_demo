require 'rails_helper'

RSpec.describe Formula, type: :model do

  let(:formula) { build(:formula) }

  it 'should be valid' do
    expect(formula).to be_valid
  end

  describe 'it should require' do
    it 'a service' do
      formula.service = nil
      expect(formula).to_not be_valid
    end

    # it 'a time' do
    #   formula.time = nil
    #   expect(formula).to_not be_valid
    # end
    #
    # it 'a weight' do
    #   formula.weight = nil
    #   expect(formula).to_not be_valid
    # end
    #
    # it 'a volume' do
    #   formula.volume = nil
    #   expect(formula).to_not be_valid
    # end

  end
end
