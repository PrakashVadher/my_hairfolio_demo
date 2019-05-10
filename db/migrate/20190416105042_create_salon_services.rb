class CreateSalonServices < ActiveRecord::Migration[5.2]
  def change
    create_table :salon_services do |t|
      t.references :salon, foreign_key: true
      t.string :name
      t.text :description
      t.string :price

      t.timestamps
    end
  end
end
