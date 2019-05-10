class CreateClaims < ActiveRecord::Migration[5.2]
  def change
    create_table :claims do |t|
      t.references :salon, foreign_key: true
      t.string :email
      t.string :contact_number
      t.boolean :approve

      t.timestamps
    end
  end
end
