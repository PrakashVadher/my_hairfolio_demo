class DiscountSlider < ApplicationRecord
	belongs_to :product
	mount_uploader :banner_image, AttachmentUploader
	validates_presence_of :banner_image
	validate :check_record, on: :create
	validate :validate_minimum_image_size

	def validate_minimum_image_size	  
	  return if banner_image.path.exclude? "tmp"
	  image = MiniMagick::Image.open(banner_image.path) 
	  unless image[:width] >= 1920 && image[:height] >= 720
	    errors.add :banner_image, "should be 1920x720px minimum!" 
	  end
	end

	def check_record
		errors.add(:base, "You can't create more than one") if DiscountSlider.first.present?		
	end
end
