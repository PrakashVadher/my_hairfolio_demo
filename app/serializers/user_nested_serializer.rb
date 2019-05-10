class UserNestedSerializer < ActiveModel::Serializer
  attributes :id, :auth_token, :email, :first_name, :last_name, :auth_token, :likes_count, :followers_count, :account_type, :salon, :brand, :avatar_url, :avatar_cloudinary_id, :share_facebook, :share_twitter, :share_instagram, :share_pinterest, :share_tumblr, :facebook_token, :instagram_token, :twitter_token, :pinterest_token, :prof_desc, :years_exp, :career_opportunity, :is_following_me, :is_followed_by_me
  has_many :educations
  has_many :offerings
  has_many :experiences
  has_many :certificates

  def likes_count
    object.likes.length
  end

  def followers_count
    object.followers.length
  end

  def salon
    SalonSerializer.new(object.salon, {scope: scope}).serializable_hash if object.salon
  end

  def brand
    BrandSerializer.new(object.brand, {scope: scope}).serializable_hash if object.brand
  end

  def is_following_me
    scope && scope.current_user && object.following?(scope.current_user)
  end

  def is_followed_by_me
    scope && scope.current_user && object.followers?(scope.current_user)
  end
end
