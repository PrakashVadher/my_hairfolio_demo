class Favourite < ApplicationRecord
  belongs_to :product, counter_cache: true
  belongs_to :user
  validates_presence_of :product, :user
  validates_uniqueness_of :product, scope: :user
  
  # after_create :notify_owner
  # has_many :notifications
  # # Add new column name as favourite_id in notifications table
  # def notify_owner
  #   Notification.create!(user: user, body: "#{product.name} Added to Your Wish List.", notifiable: self)
  # end
  
end
