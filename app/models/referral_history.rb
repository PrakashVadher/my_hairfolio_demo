class ReferralHistory < ApplicationRecord
  belongs_to :referral_recipient, foreign_key: :referral_recipient_id, class_name: 'User'
  belongs_to :referrer, foreign_key: :referrer_id, class_name: 'User'
end
