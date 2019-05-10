class CreatePostsTags < ActiveRecord::Migration[5.0]
  def change
    create_table :posts_tags, id: false do |t|
      t.references :post
      t.references :tag
    end
  end
end
