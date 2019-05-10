class CreateReferHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :refer_histories do |t|
      t.references :refer, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
