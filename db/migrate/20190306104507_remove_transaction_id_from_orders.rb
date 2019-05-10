class RemoveTransactionIdFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :transaction_id
  end
end
