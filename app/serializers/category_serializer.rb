class CategorySerializer < ActiveModel::Serializer
  
  attributes :id, :created_at, :name, :image, :sub_categories
  has_many :products

  def products
    object.products.order("id DESC")
  end

  def image
  	object.image.url
  end

  def sub_categories
    Category.where(ancestry: object.id)
  end

end
