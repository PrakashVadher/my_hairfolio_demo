class AddAssetUrlToContact < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :asset_url, :string
  end
end
