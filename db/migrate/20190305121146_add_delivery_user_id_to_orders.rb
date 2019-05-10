class AddDeliveryUserIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :delivery_user, references: :user
  end
end
