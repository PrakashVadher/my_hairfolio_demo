class SalonImage < ApplicationRecord
  belongs_to :salon

  validates_presence_of :image_url
end
