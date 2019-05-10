class RemovePostshowTypeToHomepages < ActiveRecord::Migration[5.2]
  def change
  	remove_column :homepages, :postshow_type
  end
end
