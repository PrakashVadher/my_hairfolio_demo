class PostMinimalSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :description, :likes_count, :comments_count, :liked_by_me, :user
  has_many :photos
  
  def user
    UserMinimalSerializer.new(object.user).serializable_hash if object.user
  end

  def liked_by_me
    object.user.likes.pluck(:post_id).include?(object.id)
  end

end
