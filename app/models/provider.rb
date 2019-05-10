class Provider < ApplicationRecord
  has_many :authentications
  validates_presence_of :name

  scope :facebook, -> { where(name: 'facebook').first }
  scope :instagram, -> { where(name: 'instagram').first }
end
