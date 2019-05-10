class GlobalVar < ApplicationRecord
  validates :name, presence: :true
  validates :value, :numericality => {:greater_than_or_equal_to => 1}
  validates_length_of :value, maximum: 6, presence: true
end
