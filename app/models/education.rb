class Education < ApplicationRecord
  belongs_to :degree
  belongs_to :user

  validates_presence_of :degree, :name, :year_from, :year_to
end
