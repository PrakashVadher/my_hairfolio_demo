class AddCountryCodeToContacts < ActiveRecord::Migration[5.2]
  def change
  	add_column :contacts, :country_code , :string
  end
end
