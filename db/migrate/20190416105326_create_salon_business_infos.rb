class CreateSalonBusinessInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :salon_business_infos do |t|
      t.references :salon, foreign_key: true
      t.string :info_name
      t.string :info_value

      t.timestamps
    end
  end
end
