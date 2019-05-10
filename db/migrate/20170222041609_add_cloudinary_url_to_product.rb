class AddCloudinaryUrlToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :cloudinary_url, :string
  end
end
