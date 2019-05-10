class CreateDiscountSliders < ActiveRecord::Migration[5.2]
  def change
    create_table :discount_sliders do |t|
      t.string :banner_image
      t.integer :product_id

      t.timestamps
    end
  end
end
