class Photo < ApplicationRecord
  #mount_uploader :asset_url, AttachmentUploader
  belongs_to :post
  has_many :labels, dependent: :destroy
  has_many :tags, through: :labels
  accepts_nested_attributes_for :labels, allow_destroy: true
  # validates_presence_of :asset_url
  # after_create :update_last_photo
  # after_create :warm_cache
  
  private
  # def update_last_photo
  #   tags.each do |tag|
  #     tag.update(last_photo: asset_url)
  #   end
  # end

  # def warm_cache
  #   require 'open-uri'
  #   split_url = asset_url.split('upload')
  #   [80, 120, 32, 40, 195, 220, 2250, 1500, 2160, 1280].each do |width|
  #     new_url = "#{split_url[0]}upload/w_#{width}#{split_url[1]}"
  #     open(new_url) rescue true
  #   end unless Rails.env.test?
  # end
end
