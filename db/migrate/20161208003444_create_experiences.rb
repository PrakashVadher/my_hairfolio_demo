class CreateExperiences < ActiveRecord::Migration[5.0]
  def change
    create_table :experiences do |t|
      t.string :name
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
