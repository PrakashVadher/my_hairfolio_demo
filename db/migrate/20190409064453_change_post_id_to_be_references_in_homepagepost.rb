class ChangePostIdToBeReferencesInHomepagepost < ActiveRecord::Migration[5.2]
  def change
    remove_column :homepageposts, :postid
  end
end
