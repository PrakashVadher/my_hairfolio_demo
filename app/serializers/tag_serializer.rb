class TagSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :last_photo
end
