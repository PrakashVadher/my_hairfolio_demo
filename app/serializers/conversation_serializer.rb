class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :created_at, :last_message, :recipient_ids, :unread_messages, :recipients

  def recipients
    object.recipients ? object.recipients.map { |u| UserMinimalSerializer.new(u).serializable_hash } : []
  end

  def last_message
    MessageMinimalSerializer.new(object.messages.last, {scope: scope}).serializable_hash if object.messages.any?
  end

  def unread_messages
    scope && scope.current_user ? (object.messages.where(read: false).where('user_id != ?', scope.current_user.id).length > 0) : 0
  end

  def recipient_ids
    object.recipient_ids ? object.recipient_ids.map { |r| r.to_i } : []
  end
end
