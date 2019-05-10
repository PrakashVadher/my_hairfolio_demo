class AddReadToPushNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :push_notifications, :read, :boolean, default: false
  end
end
