class AddAutoFollowToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :auto_follow, :boolean, default: false
  end
end
