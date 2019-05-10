class CardSerializer < ActiveModel::Serializer
  attributes :id, :stripe_card_id, :is_primary
end
