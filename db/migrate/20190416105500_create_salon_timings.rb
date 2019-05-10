class CreateSalonTimings < ActiveRecord::Migration[5.2]
  def change
    create_table :salon_timings do |t|
      t.references :salon, foreign_key: true
      t.integer :week_day
      t.time :open_time
      t.time :close_time
      t.boolean :is_closed

      t.timestamps
    end
  end
end
