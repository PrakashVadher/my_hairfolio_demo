class EmailSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :email, :email_type
end
