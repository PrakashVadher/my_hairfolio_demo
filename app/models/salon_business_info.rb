class SalonBusinessInfo < ApplicationRecord
  belongs_to :salon
  validates_presence_of :info_value, :info_name
end
