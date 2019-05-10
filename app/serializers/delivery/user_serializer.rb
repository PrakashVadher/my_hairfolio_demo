class Delivery::UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :auth_token, :account_type
end