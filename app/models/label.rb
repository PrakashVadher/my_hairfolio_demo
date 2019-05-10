class Label < ApplicationRecord
  belongs_to :photo
  belongs_to :tag, counter_cache: true
  has_many :formulas, dependent: :destroy
  accepts_nested_attributes_for :formulas, allow_destroy: true
  validates_presence_of :position_top, :position_left

  enum label_type: [:hash_tag, :url, :product, :service]
end
