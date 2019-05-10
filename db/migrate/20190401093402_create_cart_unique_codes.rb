class CreateCartUniqueCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_unique_codes do |t|
      t.references :cart, foreign_key: true
      t.string :unique_code

      t.timestamps
    end
  end
end
