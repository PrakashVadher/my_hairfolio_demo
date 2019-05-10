class Follow < ApplicationRecord
  has_many :notifications, as: :notifiable
  belongs_to :follower, foreign_key: 'follower_id', class_name: 'User'
  belongs_to :following, foreign_key: 'following_id', class_name: 'User'
  validates_presence_of :follower, :following
  after_create :notify_following

  def notify_following
    Notification.create!(user: following, body: "#{follower.first_name} #{follower.last_name} is now following you.", notifiable: self)
  end
end
