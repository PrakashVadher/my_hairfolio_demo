class CreateShampoos < ActiveRecord::Migration[5.2]
  def change
    create_table :shampoos do |t|
      t.string :name

      t.timestamps
    end
  end
end
