class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.references :user, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :address

      t.timestamps
    end
  end
end
