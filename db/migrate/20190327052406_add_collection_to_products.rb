class AddCollectionToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :collection, foreign_key: true, index: true
  end
end
