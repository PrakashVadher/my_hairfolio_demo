class AddSocialTokens < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :facebook_token, :string
    add_column :users, :twitter_token, :string
    add_column :users, :instagram_token, :string
    add_column :users, :pinterest_token, :string
  end
end
