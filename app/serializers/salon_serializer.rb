class SalonSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :info, :address, :city, :state, :zip, :website, :phone, :can_claim, :latitude, :longitude
end
