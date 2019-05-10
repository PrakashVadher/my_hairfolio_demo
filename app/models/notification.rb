class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  validates_presence_of :user, :notifiable, :body
  scope :following, -> (user) { where(user: user.following) }
end
