class HomepageSerializer < ActiveModel::Serializer
  attributes :id, :title_heading, :status, :created_at, :updated_at
  has_many :posts
end