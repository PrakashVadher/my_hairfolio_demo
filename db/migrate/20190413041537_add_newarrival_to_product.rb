class AddNewarrivalToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :new_arrival, :boolean, after: :is_trending
  end
end
