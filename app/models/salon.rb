class Salon < ApplicationRecord
  attr_accessor :can_claim

  extend Geocoder::Model::ActiveRecord
  geocoded_by :full_street_address
  reverse_geocoded_by :latitude, :longitude

  validates_presence_of :name
  has_many :users, dependent: :destroy
  has_one :owner, class_name: 'User'
  has_many :salon_images, dependent: :destroy
  has_many :salon_business_infos, dependent: :destroy
  has_many :salon_timings, dependent: :destroy
  has_many :salon_services, dependent: :destroy
  has_and_belongs_to_many :sections

  accepts_nested_attributes_for :salon_services, :allow_destroy => true, reject_if: :all_blank
  accepts_nested_attributes_for :salon_business_infos, :allow_destroy => true, reject_if: :all_blank
  accepts_nested_attributes_for :salon_images, :allow_destroy => true, reject_if: :all_blank
  accepts_nested_attributes_for :salon_timings, :allow_destroy => true, reject_if: :all_blank
  accepts_nested_attributes_for :owner, :allow_destroy => false, reject_if: :all_blank


  enum price_range: %i[inexpensive moderate pricey ultra_high_end]

  scope :search, -> (query){ where("salons.name ilike :query", query: "%#{query}") }
  scope :with_distance_to, ->(point) { select("salons.*").select("(#{distance_from_sql(point)}) as distance") }

  after_validation :geocode

  def full_street_address
    "#{address}, #{city}, #{state}, #{zip}"
  end

  def can_claim
    !owner.present?
  end
end
