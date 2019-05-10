class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :user_address
      t.string :phone
      t.string :city
      t.string :landmark
      t.string :zip_code
      t.boolean :default_address

      t.timestamps
    end
  end
end
