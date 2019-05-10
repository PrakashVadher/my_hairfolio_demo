class FavouriteSerializer < ActiveModel::Serializer
  attributes :id, :created_at
  has_one :product
  # has_one :user
  def user
    UserMinimalSerializer.new(object.user, {scope: scope}).serializable_hash
  end
  
end
