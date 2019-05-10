class ReferHistory < ApplicationRecord
  belongs_to :refer
  belongs_to :user
end
