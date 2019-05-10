class AddReferCountToRerers < ActiveRecord::Migration[5.2]
  def change
  	add_column :refers, :refer_counts, :integer
  end
end
