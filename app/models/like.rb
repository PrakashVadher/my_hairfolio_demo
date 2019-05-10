class Like < ApplicationRecord
  belongs_to :post, counter_cache: true
  belongs_to :user
  validates_presence_of :post, :user
  validates_uniqueness_of :post, scope: :user
  after_create :notify_owner
  has_many :notifications

  def notify_owner
    Notification.create!(user: post.user, body: "#{user.first_name} #{user.last_name} liked your post.", notifiable: self)
  end
end
