class EducationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :year_from, :year_to, :user_id, :website
  has_one :degree
end
