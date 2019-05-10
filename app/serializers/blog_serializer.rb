class BlogSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :image, :created_at, :updated_at
end
