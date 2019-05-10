class CreateJoinTableStylingToolProduct < ActiveRecord::Migration[5.2]
  def change
    create_join_table :styling_tools, :products do |t|
      # t.index [:styling_tool_id, :product_id]
      # t.index [:product_id, :styling_tool_id]
    end
  end
end
