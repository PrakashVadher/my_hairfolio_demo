class AddHomepagepostToPost < ActiveRecord::Migration[5.2]
  def change
    add_reference :homepageposts, :post, foreign_key: true
  end
end
