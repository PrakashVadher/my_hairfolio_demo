class Treatment < ApplicationRecord
  belongs_to :color
  belongs_to :formula
  validates_presence_of :color, :weight
end
