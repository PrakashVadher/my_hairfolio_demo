# frozen_string_literal: true

class Coupon < ApplicationRecord
  belongs_to :referent, foreign_key: :referent_id, class_name: 'User'
  belongs_to :referrer, foreign_key: :referrer_id, class_name: 'User'
  before_create :assign_coupon_code

  def assign_coupon_code
    code =
      loop do
        coupon_code = SecureRandom.hex[0, 6].upcase&.to_s
        break coupon_code unless Coupon.where(coupon_code: coupon_code).first
      end
    self.coupon_code = "COUPON#{code}"
  end

  def self.discount_percentage
    GlobalVar.find_by(name: 'referral_coupon_percentage')&.value&.to_i || 20
  end
end
