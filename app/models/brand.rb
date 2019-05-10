class Brand < ApplicationRecord
  validates_presence_of :name
  has_many :users
  has_and_belongs_to_many :services
end
