class AddDiscountAmountToOrderDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :order_details, :discount, :float, default: 0
  end
end
