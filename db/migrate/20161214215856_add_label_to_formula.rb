class AddLabelToFormula < ActiveRecord::Migration[5.0]
  def change
    add_reference :formulas, :label, foreign_key: true
  end
end
