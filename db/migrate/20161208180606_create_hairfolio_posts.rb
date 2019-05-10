class CreateHairfolioPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :folios_posts, id: false do |t|
      t.references :folio
      t.references :post
    end
  end
end
