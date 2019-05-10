class LineSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :brand, :unit

  def unit
    object.unit.to_s
  end

  def brand
    BrandSerializer.new(object.brand, {scope: scope}).serializable_hash
  end
end
