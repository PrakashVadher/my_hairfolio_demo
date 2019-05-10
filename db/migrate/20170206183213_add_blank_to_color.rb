class AddBlankToColor < ActiveRecord::Migration[5.0]
  def change
    add_column :colors, :blank, :boolean, default: false
  end
end
