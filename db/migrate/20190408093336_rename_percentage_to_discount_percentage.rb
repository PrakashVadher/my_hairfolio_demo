class RenamePercentageToDiscountPercentage < ActiveRecord::Migration[5.2]
  def change
    rename_column :sales, :percentage, :discount_percentage
  end
end
