class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :user, :created_at, :body, :notifiable, :initiator, :notifiable_type

  def initiator
    case object.notifiable.class.name
    when 'Follow'
      #object.notifiable.follower
      UserMinimalSerializer.new(object.notifiable.follower, {scope: scope}).serializable_hash if object.notifiable.follower
    when 'Like'
      #object.notifiable.user
      UserMinimalSerializer.new(object.notifiable.user, {scope: scope}).serializable_hash
    end
  end

  def user
    UserMinimalSerializer.new(object.user, {scope: scope}).serializable_hash
  end

  def notifiable_type
    object.notifiable.class.name
  end

  def notifiable
    #object.notifiable
    case object.notifiable.class.name
    when 'Follow'
      FollowSerializer.new(object.notifiable, {scope: scope}).serializable_hash
    when 'Like'
      LikeSerializer.new(object.notifiable, {scope: scope}).serializable_hash
    end
  end
end
