# frozen_string_lieral: true

module DeliverySerializersNamespace
  extend ActiveSupport::Concern

  included do
    before_action do
      self.namespace_for_serializer = 'Delivery'
    end
  end
end