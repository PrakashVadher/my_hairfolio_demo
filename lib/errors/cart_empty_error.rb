module Errors
  class CartEmptyError < Exception
    def message
      I18n.t('exceptions.cart_empty_error')
    end
  end
end