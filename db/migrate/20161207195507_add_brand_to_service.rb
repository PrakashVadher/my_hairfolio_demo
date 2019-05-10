class AddBrandToService < ActiveRecord::Migration[5.0]
  def change
    add_reference :services, :brand, foreign_key: true
  end
end
