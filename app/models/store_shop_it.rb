class StoreShopIt < ApplicationRecord
	belongs_to :product
	mount_uploader :image, AttachmentUploader
	validates_presence_of :title, :image, :description
end
