class AddPhotosVideosToMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :photo_asset_url, :string
    add_column :messages, :video_asset_url, :string
  end
end
