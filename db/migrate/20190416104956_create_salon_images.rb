class CreateSalonImages < ActiveRecord::Migration[5.2]
  def change
    create_table :salon_images do |t|
      t.references :salon, foreign_key: true
      t.text :image_url

      t.timestamps
    end
  end
end
