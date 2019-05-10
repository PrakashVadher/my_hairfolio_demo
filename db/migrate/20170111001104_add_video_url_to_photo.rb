class AddVideoUrlToPhoto < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :video_url, :string
  end
end
