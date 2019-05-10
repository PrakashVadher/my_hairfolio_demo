class Line < ApplicationRecord
  belongs_to :brand
  validates_presence_of :name, :brand, :unit
  enum unit: [:g, :oz]
end
