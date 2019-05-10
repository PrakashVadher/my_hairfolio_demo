class CreateStoreShopIts < ActiveRecord::Migration[5.2]
  def change
    create_table :store_shop_its do |t|
      t.string :title
      t.text :description
      t.string :image
      t.integer :product_id

      t.timestamps
    end
  end
end
