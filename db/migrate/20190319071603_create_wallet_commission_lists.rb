class CreateWalletCommissionLists < ActiveRecord::Migration[5.2]
  def change
    create_table :wallet_commission_lists do |t|
      t.references :order_detail, foreign_key: true
      t.float :commission_amount
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
