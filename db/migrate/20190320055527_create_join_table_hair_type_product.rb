class CreateJoinTableHairTypeProduct < ActiveRecord::Migration[5.2]
  def change
    create_join_table :hair_types, :products do |t|
      t.index [:hair_type_id, :product_id]
      # t.index [:product_id, :hair_type_id]
    end
  end
end
