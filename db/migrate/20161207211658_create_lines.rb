class CreateLines < ActiveRecord::Migration[5.0]
  def change
    create_table :lines do |t|
      t.string :name
      t.references :brand, foreign_key: true
      t.integer :unit

      t.timestamps
    end
  end
end
