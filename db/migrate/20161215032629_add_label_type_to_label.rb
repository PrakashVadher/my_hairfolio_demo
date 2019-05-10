class AddLabelTypeToLabel < ActiveRecord::Migration[5.0]
  def change
    add_column :labels, :label_type, :integer
  end
end
