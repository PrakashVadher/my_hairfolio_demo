class AddPostToFormula < ActiveRecord::Migration[5.0]
  def change
    add_reference :formulas, :photo, foreign_key: true
    add_column :formulas, :position_top, :integer
    add_column :formulas, :position_left, :integer
  end
end
