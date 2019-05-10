class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_with_token!

  def index
    notifications = Notification.includes(:user).where(nil).order('created_at desc')
    notifications = params[:following] ? notifications.following(current_user) : current_user.notifications
    notifications = notifications.page(params[:page]).per(params[:limit])
    render json: notifications, meta: pagination_dict(notifications)
  end

  def show
    notification = current_user.notifications.find(params[:id])
    render json: notification
  end

end
