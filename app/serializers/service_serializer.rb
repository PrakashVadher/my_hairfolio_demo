class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :position

end
