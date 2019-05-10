class StoreLandingSale < ApplicationRecord
	mount_uploader :image, AttachmentUploader
	validates_presence_of :title, :image, :description
end
