class CreateFormulas < ActiveRecord::Migration[5.0]
  def change
    create_table :formulas do |t|
      t.references :post, foreign_key: true
      t.references :service, foreign_key: true
      t.integer :weight
      t.integer :volume
      t.integer :time

      t.timestamps
    end
  end
end
