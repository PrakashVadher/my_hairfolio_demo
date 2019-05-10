class Contact < ApplicationRecord
  validates_presence_of :first_name
  belongs_to :user
  has_many :emails, dependent: :destroy
  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :emails, allow_destroy: true
  accepts_nested_attributes_for :phones, allow_destroy: true
  has_and_belongs_to_many :posts
  scope :order_desc,-> { order("updated_at DESC")}
end
