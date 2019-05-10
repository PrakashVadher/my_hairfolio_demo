class SalonTiming < ApplicationRecord
  enum week_day: %i[sun mon tue wed thu fri sat]
  belongs_to :salon
  validates_presence_of :week_day

end
