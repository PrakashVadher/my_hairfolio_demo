class CreateStylingTools < ActiveRecord::Migration[5.2]
  def change
    create_table :styling_tools do |t|
      t.string :name

      t.timestamps
    end
  end
end
