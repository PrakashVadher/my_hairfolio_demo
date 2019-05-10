class AddLineToFormula < ActiveRecord::Migration[5.0]
  def change
    add_reference :formulas, :line, foreign_key: true
  end
end
