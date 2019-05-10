class ColorSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :harmony_id, :code, :start_hex, :end_hex, :blank
end
