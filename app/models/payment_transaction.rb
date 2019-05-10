class PaymentTransaction < ApplicationRecord

  enum transaction_type: %i[credit debit]
  belongs_to :performer, polymorphic: true
  belongs_to :user
end
