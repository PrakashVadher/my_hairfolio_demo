class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :auth_token, :default_pinterest_board, :favourites_count, :latitude, :longitude,  :offerings, :facebook_id, :instagram_id, :last_name, :likes_count, :followers_count, :account_type, :is_following_me, :is_followed_by_me, :salon, :brand, :avatar_url, :avatar_cloudinary_id, :share_facebook, :share_twitter, :share_instagram, :share_pinterest, :share_tumblr, :prof_desc, :description, :years_exp, :career_opportunity, :unread_messages_count, :referral_code, :permission
  has_many :likes
  has_many :favourites
  has_many :educations
  has_many :experiences
  has_many :certificates
  has_many :contacts
  has_many :posts
  has_many :addresses

  def auth_token
    if object.id == @instance_options[:user_id]
        object.auth_token
    end    
  end

  def offerings
    object.offerings.map { |o| OfferingSerializer.new(o, {scope: scope}).serializable_hash }
  end

  def likes_count
    object.likes.uniq.length
  end

  def favourites_count
    object.favourites.uniq.length
  end

  def followers_count
    object.followers.uniq.length
  end

  def salon
    SalonSerializer.new(object.salon, {scope: scope}).serializable_hash if object.salon
  end

  def brand
    BrandSerializer.new(object.brand, {scope: scope}).serializable_hash if object.brand
  end

  # def facebook_id
  #   object.authentications.facebook.first.try(:uid) if object.authentications.instagram.any?
  # end
  #
  # def instagram_id
  #   object.authentications.instagram.first.try(:uid) if object.authentications.instagram.any?
  # end

  def is_following_me
    scope && scope.current_user && object.following?(scope.current_user)
  end

  def is_followed_by_me
    scope && scope.current_user && object.followers?(scope.current_user)
  end

  def permission
    if object.warehouse?
      ['product']
    elsif object.delivery?
      ['order']
    else
      []
    end
  end
end
