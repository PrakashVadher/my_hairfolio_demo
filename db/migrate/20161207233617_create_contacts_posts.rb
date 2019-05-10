class CreateContactsPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts_posts, id: false do |t|
      t.references :contact, foreign_key: true
      t.references :post, foreign_key: true
    end
  end
end
