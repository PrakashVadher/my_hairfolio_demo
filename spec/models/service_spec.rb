require 'rails_helper'

RSpec.describe Service, type: :model do

  let(:service) { build(:service)}

  it 'should be valid' do
    expect(service).to be_valid
  end

  describe 'should require' do
    it 'a name' do
      service.name = nil
      expect(service).to_not be_valid
    end
  end
end
