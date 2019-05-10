class AddLastPhotoToTag < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :last_photo, :string
    Photo.order('created_at asc').each do |photo|
      photo.tags.each do |tag|
        tag.update(last_photo: photo.asset_url)
      end
    end
  end
end
