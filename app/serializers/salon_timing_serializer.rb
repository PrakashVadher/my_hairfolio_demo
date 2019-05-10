class SalonTimingSerializer < ActiveModel::Serializer
  attributes :id, :week_day, :open_time, :close_time, :is_closed
end