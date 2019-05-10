class CreateReferralHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :referral_histories do |t|
      t.references :referrer, referrences: :user
      t.references :referral_recipient, referrences: :user
      t.string :referral_code

      t.timestamps
    end
  end
end
