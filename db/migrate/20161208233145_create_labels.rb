class CreateLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :labels do |t|
      t.references :tag, foreign_key: true
      t.references :post, foreign_key: true
      t.integer :position_top
      t.integer :position_left

      t.timestamps
    end
  end
end
