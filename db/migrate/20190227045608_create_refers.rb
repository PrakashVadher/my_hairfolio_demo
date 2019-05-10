class CreateRefers < ActiveRecord::Migration[5.2]
  def change
    create_table :refers do |t|
      t.string :unique_code, unique: true
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
