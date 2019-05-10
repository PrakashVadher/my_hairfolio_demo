class ExperienceSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :position
end
