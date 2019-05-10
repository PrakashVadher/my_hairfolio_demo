class PaymentTransactionSerializer < ActiveModel::Serializer
  attributes :id, :transaction_type, :amount, :stripe_charge_id
end
