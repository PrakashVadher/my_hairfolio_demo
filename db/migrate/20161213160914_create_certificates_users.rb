class CreateCertificatesUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :certificates_users, id: false do |t|
      t.references :certificate
      t.references :user
    end
  end
end
