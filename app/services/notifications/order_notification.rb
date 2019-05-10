# frozen_string_literal: true

module Notifications
  class OrderNotification
    attr_accessor :order, :for_activity
    def initialize(order:, for_activity:)
      @order = order
      @for_activity = for_activity
    end

    def generate
      PushNotification.create!(notification_params)
    end

    private

    def notification_params
      {
        notifier: @order,
        status: :scheduled,
        notification_for: for_activity,
        user: @order.user,
        title: I18n.t("notifications.#{for_activity}.title"),
        message: I18n.t("notifications.#{for_activity}.message", order_number: order.order_number)
      }
    end
  end
end