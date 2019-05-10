class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|
      t.references :referent, references: :user
      t.references :referrer, references: :user
      t.string :coupon_code

      t.timestamps
    end
  end
end
