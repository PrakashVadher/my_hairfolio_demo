class AddLabelsCountToTag < ActiveRecord::Migration[5.0]
  def change
    add_column :tags, :labels_count, :integer
  end
end
