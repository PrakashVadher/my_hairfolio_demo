class CreateEducations < ActiveRecord::Migration[5.0]
  def change
    create_table :educations do |t|
      t.string :name
      t.integer :year_from
      t.integer :year_to
      t.references :degree, foreign_key: true
      t.references :user, foreign_key: true
      t.string :website

      t.timestamps
    end
  end
end
