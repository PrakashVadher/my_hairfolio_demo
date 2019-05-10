class BrandSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :name, :info, :address, :city, :state, :zip, :website, :phone
  has_many :services

end
