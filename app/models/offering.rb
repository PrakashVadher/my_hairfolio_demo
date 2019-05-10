class Offering < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :service
  validates_presence_of :category, :service, :price
end
