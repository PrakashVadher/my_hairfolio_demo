class AddDiscountToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :discount, :float, default: 0
  end
end
