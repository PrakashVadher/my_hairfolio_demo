class ChangePostshowTypeToBeBooleanInHomepage < ActiveRecord::Migration[5.2]
  def change
    remove_column :homepages, :postshow_type
    add_column :homepages, :postshow_type, :boolean
  end
end
