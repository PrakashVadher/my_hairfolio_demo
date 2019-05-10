class LikeSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :user
  has_one :post

  # def post
  #   PostSerializer.new(object.post, {scope: scope}).serializable_hash
  # end

  def user
    UserMinimalSerializer.new(object.user, {scope: scope}).serializable_hash
  end
end
