class SalonService < ApplicationRecord
  belongs_to :salon
  validates_presence_of :name
end
