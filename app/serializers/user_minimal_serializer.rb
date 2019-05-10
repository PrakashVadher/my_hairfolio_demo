class UserMinimalSerializer < ActiveModel::Serializer
  attributes :id, :avatar_url, :avatar_cloudinary_id, :first_name, :last_name, :brand_name, :salon_name, :account_type, :is_following_me, :is_followed_by_me

  def brand_name
    object.brand ? object.brand.name : nil
  end

  def salon_name
    object.salon ? object.salon.name : nil
  end

  def is_following_me
    scope && scope.current_user && object.following?(scope.current_user)
  end

  def is_followed_by_me
    scope && scope.current_user && object.followers?(scope.current_user)
  end
end
