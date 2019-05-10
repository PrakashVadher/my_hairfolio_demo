class OrderUniqueCode < ApplicationRecord
  belongs_to :order
  belongs_to :refer
end
