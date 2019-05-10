class SalonDetailSerializer < ActiveModel::Serializer
  attributes :id, :name, :info, :address, :city, :state, :zip, :website, :phone, :can_claim,
             :longitude, :latitude, :price_range, :rating, :specialities

  has_one :owner, class_name: 'User'
  has_many :salon_services
  has_many :salon_business_infos
  has_many :salon_images
  has_many :salon_timings
  has_many :sections
end
