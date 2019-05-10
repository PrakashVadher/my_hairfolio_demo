class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :transaction_id
      t.string :charge_id

      t.timestamps
    end
  end
end
