class Blog < ApplicationRecord
	validates_presence_of :title
	validates :description, presence: true
	mount_uploader :image, AttachmentUploader
end
