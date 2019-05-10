class UserListSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :account_type, :salon, :brand, :avatar_url, :avatar_cloudinary_id

  def salon
    SalonSerializer.new(object.salon, { scope: scope }).serializable_hash if object.salon
  end

  def brand
    BrandSerializer.new(object.brand, { scope: scope }).serializable_hash if object.brand
  end
end
