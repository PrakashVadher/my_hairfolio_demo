class PushNotificationSerializer < ActiveModel::Serializer
  attributes :id, :push_notification_sent_at, :read, :title, :message,
             :notification_for, :notifier

  def notifier
    case object.notifier.class.name
    when 'Order'
      OrderSerializer.new(object.notifier)
    end
  end
end