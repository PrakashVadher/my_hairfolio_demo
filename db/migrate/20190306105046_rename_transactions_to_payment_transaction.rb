class RenameTransactionsToPaymentTransaction < ActiveRecord::Migration[5.2]
  def change
    rename_table :transactions, :payment_transactions
  end
end
