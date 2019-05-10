class AddressSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :user_address, :phone, :city, :landmark, :zip_code, :default_address
end
