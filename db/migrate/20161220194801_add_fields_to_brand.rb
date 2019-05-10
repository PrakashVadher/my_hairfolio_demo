class AddFieldsToBrand < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :info, :text
    add_column :brands, :address, :string
    add_column :brands, :city, :string
    add_column :brands, :state, :string
    add_column :brands, :zip, :string
    add_column :brands, :website, :string
    add_column :brands, :phone, :string
  end
end
