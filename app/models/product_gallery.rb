class ProductGallery < ApplicationRecord
	mount_uploader :image_url, AttachmentUploader
	belongs_to :product
 	validates :image_url, presence: true
end
