class CreateStylingProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :styling_products do |t|
      t.string :name

      t.timestamps
    end
  end
end
