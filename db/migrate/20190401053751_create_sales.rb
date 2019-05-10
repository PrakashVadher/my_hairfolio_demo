class CreateSales < ActiveRecord::Migration[5.2]
  def change
    create_table :sales do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.float :percentage

      t.timestamps
    end
  end
end
