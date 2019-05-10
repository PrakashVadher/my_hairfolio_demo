class CreateOfferings < ActiveRecord::Migration[5.0]
  def change
    create_table :offerings do |t|
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.references :service, foreign_key: true
      t.integer :price

      t.timestamps
    end
  end
end
