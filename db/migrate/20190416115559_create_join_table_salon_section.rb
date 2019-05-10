class CreateJoinTableSalonSection < ActiveRecord::Migration[5.2]
  def change
    create_join_table :salons, :sections do |t|
      t.index [:salon_id, :section_id]
      # t.index [:section_id, :salon_id]
    end
  end
end
