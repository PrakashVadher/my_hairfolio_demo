class AddStylingProductToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :styling_product, foreign_key: true, index: true
  end
end
