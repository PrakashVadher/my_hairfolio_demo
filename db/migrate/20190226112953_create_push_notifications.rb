class CreatePushNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :push_notifications do |t|
      t.string :message
      t.string :title
      t.references :user
      t.datetime :push_notification_sent_at
      t.integer :status
      t.references :notifier, polymorphic: true
      t.integer :notification_for
      t.string :notification_response

      t.timestamps
    end
  end
end
