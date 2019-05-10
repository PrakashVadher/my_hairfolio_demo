# frozen_string_literal: true
#
class NotificationSender
  attr_reader :message, :device_id, :title, :badge_count

  def initialize(user:, message:, title:)
    @device_id = user.device_id
    @message = message
    @title = title
    @badge_count = user.push_notifications.where(read: false).count
  end

  def call
    begin
      resp = fcm_client.send(device_id, options)
      response_body = JSON.parse resp[:body].gsub('=>', ':')
      success = ParseBoolean.from_int_or_str(response_body.dig("success"))
      result =
        if success
          { success: true, resp_message: response_body["results"][0]["message_id"] }
        else
          { success: false, resp_message: response_body["results"][0]["error"] }
        end
      result
    rescue Exception => e
      Rails.logger.debug('Notification sending failed.')
      { success: false, resp_message: 'Exception raised' }
    end
  end

  private

  def options
    { collapse_key: 'green',
      show_in_foreground: true,
      notification: {
        title: title,
        body: message,
        badge: badge_count
      },
      data: {} }
  end

  def fcm_client
    @fcm_client ||= FCM.new(Rails.application.secrets.fcm_server_key)
  end
end
