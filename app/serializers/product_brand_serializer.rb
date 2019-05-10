class ProductBrandSerializer < ActiveModel::Serializer
  attributes :id, :title, :image, :name

  def image
  	object.image.url
  end

  def name
    object.title
  end
end
