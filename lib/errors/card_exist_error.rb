# frozen_string_literal : true

module Errors
  class CardExistError < Exception
    def message
      I18n.t('exceptions.card_exist')
    end
  end
end