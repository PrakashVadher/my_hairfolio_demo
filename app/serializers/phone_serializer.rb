class PhoneSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :number, :phone_type
end
