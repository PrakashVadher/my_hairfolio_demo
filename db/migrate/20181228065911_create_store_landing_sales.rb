class CreateStoreLandingSales < ActiveRecord::Migration[5.2]
  def change
    create_table :store_landing_sales do |t|
      t.string :title
      t.string :image
      t.text :description

      t.timestamps
    end
  end
end
