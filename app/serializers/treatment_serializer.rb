class TreatmentSerializer < ActiveModel::Serializer
  attributes :id, :created_at,:weight
  has_one :color

  # def color
  #   ColorSerializer.new(object.color, {scope: scope}).serializable_hash if object.color
  # end
end
