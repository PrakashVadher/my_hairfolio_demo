# frozen_string_literal: true

class WalletSerializer < ActiveModel::Serializer
  attributes :id, :amount
end