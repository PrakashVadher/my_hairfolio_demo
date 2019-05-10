class CreateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.string :email
      t.references :contact, foreign_key: true
      t.integer :email_type
      t.timestamps
    end
  end
end
