module Errors
  class QuantityExceedError < Exception
    def message
      I18n.t('exceptions.quantity_exceed_error')
    end
  end
end