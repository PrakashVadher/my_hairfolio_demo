class AddCoumnsToSalons < ActiveRecord::Migration[5.2]
  def change
    add_column :salons, :price_range, :integer
    add_column :salons, :rating, :float
    add_column :salons, :yelp_url, :text
    add_column :salons, :specialities, :text
    change_column :salons, :website, :text
  end
end
