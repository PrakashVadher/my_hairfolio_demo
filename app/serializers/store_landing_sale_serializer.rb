class StoreLandingSaleSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :image, :created_at, :updated_at

  def image
  	object.image.url
  end
  
end
