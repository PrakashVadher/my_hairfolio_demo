class MessageMinimalSerializer < ActiveModel::Serializer
  attributes :id,:photo_asset_url, :video_asset_url, :user, :created_at, :conversation_id, :body, :post, :url, :read

  def user
    UserMinimalSerializer.new(object.user).serializable_hash if object.user
  end

  def post
    PostMinimalSerializer.new(object.post, {scope: scope}).serializable_hash if object.post
  end
end
