class CreateBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :blocks do |t|
      t.integer :blocking_id, :null => false
      t.integer :blocker_id, :null => false

      t.timestamps
    end

    add_index :blocks, :blocking_id
    add_index :blocks, :blocker_id
    add_index :blocks, [:blocker_id, :blocking_id], unique: true
  end
end
