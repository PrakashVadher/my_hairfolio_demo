class CreateJoinTableConsistencyTypeProduct < ActiveRecord::Migration[5.2]
  def change
    create_join_table :consistency_types, :products do |t|
      # t.index [:consistency_type_id, :product_id]
      # t.index [:product_id, :consistency_type_id]
    end
  end
end
