class DiscountSliderSerializer < ActiveModel::Serializer
  attributes :id, :banner_image, :product_id, :created_at, :updated_at

  def banner_image
  	object.banner_image.url
  end
  
end
