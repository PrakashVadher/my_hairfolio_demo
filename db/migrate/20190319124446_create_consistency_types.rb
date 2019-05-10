class CreateConsistencyTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :consistency_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
