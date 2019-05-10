class Phone < ApplicationRecord
  belongs_to :contact
  validates_presence_of :number, :phone_type
  enum phone_type: [:work, :home, :mobile]
end
