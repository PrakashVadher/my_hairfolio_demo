class AddConditionerToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :conditioner, foreign_key: true, index: true
  end
end
