class OfferingSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :price, :user_id
  has_one :service
  has_one :category
end
