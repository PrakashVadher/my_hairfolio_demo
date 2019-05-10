class DegreeSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :position
end
