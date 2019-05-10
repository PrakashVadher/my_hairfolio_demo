class CreateJoinTableIngredientProduct < ActiveRecord::Migration[5.2]
  def change
    create_join_table :ingredients, :products do |t|
      # t.index [:ingredient_id, :product_id]
      # t.index [:product_id, :ingredient_id]
    end
  end
end
