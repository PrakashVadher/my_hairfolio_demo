class Section < ApplicationRecord
  has_and_belongs_to_many :salons

  validates_presence_of :name

  scope :search, -> (query) { where('name ilike ?', query) }
end
