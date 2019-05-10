class AddDiscountPercentageToCoupons < ActiveRecord::Migration[5.2]
  def change
    add_column :coupons, :discount_percentage, :float, default: 0
  end
end
