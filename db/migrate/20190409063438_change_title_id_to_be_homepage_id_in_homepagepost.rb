class ChangeTitleIdToBeHomepageIdInHomepagepost < ActiveRecord::Migration[5.2]
  def change
    rename_column :homepageposts, :title_id, :homepage_id
  end
end
