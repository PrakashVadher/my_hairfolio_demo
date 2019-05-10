class CreateColors < ActiveRecord::Migration[5.0]
  def change
    create_table :colors do |t|
      t.references :harmony, foreign_key: true
      t.string :code
      t.string :start_hex
      t.string :end_hex

      t.timestamps
    end
  end
end
