class CreateHomepages < ActiveRecord::Migration[5.2]
  def change
    create_table :homepages do |t|
      t.string :title_heading
      t.integer :postshow_type
      t.integer :status

      t.timestamps
    end
  end
end
