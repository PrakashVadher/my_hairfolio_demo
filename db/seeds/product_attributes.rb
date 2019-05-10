require 'csv'

product_types = []
hair_types = []
consistency = []
ingredients = []
preferences = []
styling_tools = []
CSV.foreach(Rails.root.join('public/product_attributes.csv'), :headers => true) do |row|
  row = row.to_h
  next if row['product_type'].nil?
  product_types << { name: row['product_type'] }
  hair_types << { name: row['hair_type'] }
  consistency << { name: row['consistency'] }
  ingredients << { name: row['ingredient'] }
  preferences << { name: row['preference'] }
  styling_tools << { name: row['styling_tool'] }
end

ProductType.import product_types, on_duplicate_key_update: true
HairType.import hair_types, on_duplicate_key_update: true
ConsistencyType.import consistency, on_duplicate_key_update: true
Ingredient.import ingredients, on_duplicate_key_update: true
Preference.import preferences, on_duplicate_key_update: true
StylingTool.import styling_tools, on_duplicate_key_update: true


collections = []
shampoos = []
conditioners = []
styling_products = []
CSV.foreach(Rails.root.join('public/additional_product_attributes.csv'), headers: true) do |row|
  row = row.to_h
  collections << { name: row['Collections'] }  unless row['Collections'].nil?
  shampoos << { name: row['Shampoo'] } unless row['Shampoo'].nil?
  conditioners << { name: row['Conditioner'] }  unless row['Conditioner'].nil?
  styling_products << { name: row['Styling Products'] }  unless row['Styling Products'].nil?
end

Collection.import! collections, on_duplicate_key_update: true
Shampoo.import! shampoos, on_duplicate_key_update: true
Conditioner.import! conditioners, on_duplicate_key_update: true
StylingProduct.import! styling_products, on_duplicate_key_update: true