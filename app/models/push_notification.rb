class PushNotification < ApplicationRecord
  belongs_to :user
  belongs_to :notifier, polymorphic: true
  enum notification_for: %i[order_created order_delivered order_in_progress order_confirmed]
  enum status: %i[scheduled delivered failed cancelled]

  scope :unread, -> { where(read: false) }
end
