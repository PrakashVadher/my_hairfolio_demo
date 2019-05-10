class Video < ApplicationRecord
  belongs_to :post
  validates_presence_of :asset_url
end
