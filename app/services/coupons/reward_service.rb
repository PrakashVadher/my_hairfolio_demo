# frozen_string_literal: true

module Coupons
  class RewardService
    attr_accessor :referant_user, :referral_code
    def initialize(referant_user: ,referral_code:)
      @referral_code = referral_code
      @referant_user = referant_user
    end

    def apply
      referral_user = User.select(:id, :referral_code).find_by(referral_code: referral_code)
      return unless referral_user
      coupon = Coupon.find_or_create_by!(referrer_id: referral_user.id, referent_id: referant_user.id)
      coupon.update!(discount_percentage: Coupon.discount_percentage)
      ReferralHistory.find_or_create_by!(referrer_id: referral_user.id,
                                         referral_code: referral_user.referral_code,
                                         referral_recipient_id: referant_user.id)
    end
  end
end