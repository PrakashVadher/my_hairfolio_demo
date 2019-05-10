class FolioSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :last_post, :posts_count

  def last_post
    PostSerializer.new(object.posts.last).serializable_hash if object.posts.any?
  end

  def posts_count
    object.posts.length
  end
end
