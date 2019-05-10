class Formula < ApplicationRecord
  belongs_to :service
  belongs_to :label
  belongs_to :line
  validates_presence_of :service#, :time, :weight, :volume
  has_many :treatments, dependent: :destroy
  has_many :colors, through: :treatments
  accepts_nested_attributes_for :treatments, allow_destroy: true
end
