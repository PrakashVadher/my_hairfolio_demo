class CreateTreatments < ActiveRecord::Migration[5.0]
  def change
    create_table :treatments do |t|
      t.references :color, foreign_key: true
      t.references :formula, foreign_key: true
      t.integer :weight

      t.timestamps
    end
  end
end
