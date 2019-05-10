class CreateOrderUniqueCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :order_unique_codes do |t|
      t.references :order, foreign_key: true
      t.references :refer, foreign_key: true

      t.timestamps
    end
  end
end
