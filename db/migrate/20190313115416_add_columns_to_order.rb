class AddColumnsToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :wallet_amount, :float, default: 0
    add_column :orders, :coupon_amount, :float, default: 0
    add_column :orders, :final_amount, :float, default: 0
  end
end
