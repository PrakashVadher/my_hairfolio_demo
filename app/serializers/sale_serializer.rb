class SaleSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :end_date, :image, :discount_percentage, :active

  def start_date
    object.start_date.iso8601
  end

  def end_date
    object.end_date.iso8601
  end

  def image
    object.image
  end
end