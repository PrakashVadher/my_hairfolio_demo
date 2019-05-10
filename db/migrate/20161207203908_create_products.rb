class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.references :tag, foreign_key: true
      t.string :image_url
      t.string :link_url

      t.timestamps
    end
  end
end
