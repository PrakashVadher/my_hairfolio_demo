class ChangePriceColumnToDecimal < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :price, :decimal, :precision => 15, :scale => 6, null: false
  end
end
