class AddFacebookIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :facebook_id, :string
    add_column :users, :instagram_id, :string
    User.find_each do |u|
      u.update(facebook_id: u.authentications.facebook.first.try(:uid))
      u.update(instagram_id: u.authentications.instagram.first.try(:uid))
    end
  end
end
