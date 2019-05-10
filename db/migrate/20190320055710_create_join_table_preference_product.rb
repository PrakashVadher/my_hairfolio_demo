class CreateJoinTablePreferenceProduct < ActiveRecord::Migration[5.2]
  def change
    create_join_table :preferences, :products do |t|
      # t.index [:preference_id, :product_id]
      # t.index [:product_id, :preference_id]
    end
  end
end
