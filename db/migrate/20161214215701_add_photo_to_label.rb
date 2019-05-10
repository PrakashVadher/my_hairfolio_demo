class AddPhotoToLabel < ActiveRecord::Migration[5.0]
  def change
    add_reference :labels, :photo, foreign_key: true
  end
end
