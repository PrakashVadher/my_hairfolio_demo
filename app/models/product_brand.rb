class ProductBrand < ApplicationRecord
	mount_uploader :image, AttachmentUploader
	validates_presence_of :title, :image
	validates_length_of :title, minimum: 3,maximum: 100
end
