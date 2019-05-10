class ChangeAmountFieldInPaymentTransactions < ActiveRecord::Migration[5.2]
  def change
    change_column :payment_transactions, :amount, :float, default: 0.0
  end
end
