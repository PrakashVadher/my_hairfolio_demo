class CreateBrandsServices < ActiveRecord::Migration[5.0]
  def change
    create_table :brands_services, id: false do |t|
      t.references :brand
      t.references :service
    end
  end
end
