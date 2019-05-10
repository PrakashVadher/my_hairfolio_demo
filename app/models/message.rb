class Message < ApplicationRecord
  validates_presence_of :conversation, :user
  belongs_to :conversation, touch: true
  belongs_to :user
  belongs_to :post
end
