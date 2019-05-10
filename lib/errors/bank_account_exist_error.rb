# frozen_string_literal : true

module Errors
  class BankAccountExistError < Exception
    def message
      I18n.t('exceptions.bank_account_exist')
    end
  end
end