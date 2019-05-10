class CreateDegrees < ActiveRecord::Migration[5.0]
  def change
    create_table :degrees do |t|
      t.string :name
      t.integer :postion, default: 0

      t.timestamps
    end
  end
end
