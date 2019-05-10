class CreateExperiencesUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :experiences_users, id: false do |t|
      t.references :experience
      t.references :user
    end
  end
end
