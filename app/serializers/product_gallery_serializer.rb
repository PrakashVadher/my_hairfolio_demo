class ProductGallerySerializer < ActiveModel::Serializer
  attributes :image_url, :id
  def image_url
  	object.image_url.url
  end 
end
