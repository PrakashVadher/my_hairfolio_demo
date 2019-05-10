# frozen_string_lieral: true

module WarehouseSerializerNamespace
  extend ActiveSupport::Concern

  included do
    before_action do
      self.namespace_for_serializer = 'Warehouse'
    end
  end
end