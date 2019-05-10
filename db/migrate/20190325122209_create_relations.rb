class CreateRelations < ActiveRecord::Migration[5.2]
  def change
    create_table :relations do |t|
      t.references :product, foreign_key: true, index: true
      t.references :related_product, referrences: :product

      t.timestamps
    end

    add_index :relations, [:product_id, :related_product_id], unique: true
  end
end
