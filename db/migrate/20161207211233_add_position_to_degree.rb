class AddPositionToDegree < ActiveRecord::Migration[5.0]
  def change
    add_column :degrees, :position, :integer, default: 0
  end
end
