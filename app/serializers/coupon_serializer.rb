class CouponSerializer < ActiveModel::Serializer
  attributes :id, :coupon_code, :discount_percentage, :description, :created_at

  def description
    I18n.t('coupons.description', discount_percentage: format_percentage, coupon_code: object.coupon_code)
  end

  def created_at
    object.created_at.iso8601
  end

  def discount_percentage
    format_percentage
  end

  def format_percentage
    if (object.discount_percentage - object.discount_percentage.floor) > 0
      object.discount_percentage
    else
      object.discount_percentage.floor
    end
  end
end
