class Cart < ApplicationRecord
	belongs_to :product
	belongs_to :user

	has_many :cart_unique_codes, dependent: :destroy
end
