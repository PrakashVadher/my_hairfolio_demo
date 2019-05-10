class CreateAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :authentications do |t|
      t.references :provider, foreign_key: true
      t.references :user, foreign_key: true
      t.string :uid
      t.string :token
      t.datetime :token_expires_at
      t.string :username
      t.text :params

      t.timestamps
    end
  end
end
