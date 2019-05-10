class RemoveUniqueIndex < ActiveRecord::Migration[5.0]
  def change
    remove_index :follows, [:following_id, :follower_id]
  end
end
