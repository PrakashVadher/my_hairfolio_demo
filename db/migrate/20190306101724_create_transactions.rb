class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :performer, polymorphic: true
      t.integer :amount
      t.integer :transaction_type
      t.string :stripe_charge_id
      t.references :user


      t.timestamps
    end
  end
end
