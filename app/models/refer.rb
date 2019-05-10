class Refer < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :refer_histories
end
