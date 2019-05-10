# frozen_string_literal: true

class  Api::V1::PushNotificationsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :set_push_notification, only: :update

  def index
    push_notifications = @current_user.push_notifications
                                      .order(created_at: :desc)
                                      .paginate(pagination_params)
    success(data: push_notifications, meta: pagination_dict(push_notifications))
  end

  def update
    @push_notification.update!(push_notification_params)
    success(data: PushNotificationSerializer.new(@push_notification).serializable_hash)
  end

  def reset_badge_count
    @current_user.push_notifications.unread.update_all(read: true)
    success(data: { message: 'Reset successfully.' })
  end

  private

  def set_push_notification
    @push_notification = @current_user.push_notifications.find(params[:id])
  end

  def push_notification_params
    params.require(:push_notification).permit(:read)
  end
end