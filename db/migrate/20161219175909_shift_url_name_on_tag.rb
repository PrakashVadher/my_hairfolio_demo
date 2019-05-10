class ShiftUrlNameOnTag < ActiveRecord::Migration[5.0]
  def change
    remove_column :tags, :url, :string
    add_column :labels, :url, :string
    add_column :labels, :name, :string
  end
end
