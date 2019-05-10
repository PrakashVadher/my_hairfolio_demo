class AddImageToSale < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :image, :string
  end
end
