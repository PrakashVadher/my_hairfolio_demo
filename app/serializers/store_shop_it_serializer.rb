class StoreShopItSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :image, :product_id, :created_at, :updated_at

  def image
  	object.image.url
  end
  
end
