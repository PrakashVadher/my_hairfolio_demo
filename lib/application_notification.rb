# frozen_string_literal: true

class ApplicationNotification
  attr_accessor :notification
  def initialize(notification:)
    @notification = notification
  end

  def deliver
    deliver_push
  end

  def deliver_push
    if notification.scheduled?
      return unless notification.user&.device_id&.present?

      resp = NotificationSender
             .new(user: notification.user, title: notification.title, message: notification.message)
             .call
      status = resp[:success] ? :delivered : :failed
      notification.update!(status: status, notification_response: resp[:resp_message], push_notification_sent_at: Time.now.utc)
    end
  end
end