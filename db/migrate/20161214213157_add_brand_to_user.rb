class AddBrandToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :brand, foreign_key: true
  end
end
