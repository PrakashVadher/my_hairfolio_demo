class AddStandardToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :account_type, :integer
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :avatar_url, :string
    add_column :users, :avatar_cloudinary_id, :string
    add_column :users, :share_facebook, :boolean, default: false
    add_column :users, :share_twitter, :boolean, default: false
    add_column :users, :share_instagram, :boolean, default: false
    add_column :users, :share_pinterest, :boolean, default: false
    add_column :users, :share_tumblr, :boolean, default: false
    add_column :users, :prof_desc, :text
    add_column :users, :years_exp, :integer
    add_reference :users, :salon, foreign_key: true
    add_column :users, :career_opportunity, :text
  end
end
