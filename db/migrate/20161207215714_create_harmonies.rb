class CreateHarmonies < ActiveRecord::Migration[5.0]
  def change
    create_table :harmonies do |t|
      t.references :line, foreign_key: true
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
