class CreateHomepageposts < ActiveRecord::Migration[5.2]
  def change
    create_table :homepageposts do |t|
      t.integer :title_id
      t.integer :postid

      t.timestamps
    end
  end
end
