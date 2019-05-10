class AddDefaultBoardToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :default_pinterest_board, :string
  end
end
