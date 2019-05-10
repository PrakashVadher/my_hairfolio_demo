class CreateConditioners < ActiveRecord::Migration[5.2]
  def change
    create_table :conditioners do |t|
      t.string :name

      t.timestamps
    end
  end
end
