class AddShampooToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :shampoo, foreign_key: true, index: true
  end
end
