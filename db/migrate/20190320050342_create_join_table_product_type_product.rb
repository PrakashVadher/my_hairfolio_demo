class CreateJoinTableProductTypeProduct < ActiveRecord::Migration[5.2]
  def change
    create_join_table :product_types, :products do |t|
      t.index [:product_type_id, :product_id]
      # t.index [:product_id, :product_type_id]
    end
  end
end
