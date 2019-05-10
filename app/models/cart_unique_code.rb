class CartUniqueCode < ApplicationRecord
  belongs_to :cart
  validates :unique_code, presence: true
end
