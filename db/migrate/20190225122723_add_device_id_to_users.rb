class AddDeviceIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :device_id, :string
  end
end
