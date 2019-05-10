class AddFieldsToSalon < ActiveRecord::Migration[5.0]
  def change
    add_column :salons, :info, :text
    add_column :salons, :address, :text
    add_column :salons, :city, :string
    add_column :salons, :state, :string
    add_column :salons, :zip, :string
    add_column :salons, :website, :string
    add_column :salons, :phone, :string
  end
end
