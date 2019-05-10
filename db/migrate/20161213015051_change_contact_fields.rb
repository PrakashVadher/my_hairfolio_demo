class ChangeContactFields < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :city, :string
    add_column :contacts, :state, :string
    add_column :contacts, :zipcode, :string
    add_column :contacts, :photo_url, :string
  end
end
