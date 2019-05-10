class Degree < ApplicationRecord
  validates_presence_of :name
  has_many :educations
end
