class Block < ApplicationRecord
  belongs_to :blocker, foreign_key: :blocker_id, class_name: 'User'
  belongs_to :blocking, foreign_key: :blocking_id, class_name: 'User'

  validates_presence_of :blocker, :blocking
end
