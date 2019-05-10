class Product < ApplicationRecord
  attr_accessor :final_price
  mount_uploader :product_image, ProductImageUploader
  acts_as_paranoid
  has_many :product_galleries  
  accepts_nested_attributes_for :product_galleries, :allow_destroy => true, reject_if: :all_blank

  belongs_to :tag
  has_and_belongs_to_many :posts
  belongs_to :user
  belongs_to :product_brand
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :product_types
  has_and_belongs_to_many :hair_types
  has_and_belongs_to_many :ingredients
  has_and_belongs_to_many :preferences
  has_and_belongs_to_many :consistency_types
  has_and_belongs_to_many :styling_tools
  accepts_nested_attributes_for :categories, :allow_destroy => true, reject_if: :all_blank

  has_many :favourites, dependent: :destroy
  has_many :relations
  has_many :related_products, through: :relations, dependent: :destroy
  belongs_to :collection
  belongs_to :shampoo
  belongs_to :conditioner
  belongs_to :styling_product

  has_one :item, dependent: :destroy
  has_one :sale, through: :item
  has_one :active_sale_item, -> { joins(:sale).where('sales.start_date <= :current_time AND sales.end_date >= :current_time', current_time: Time.now.utc) }, class_name: 'Item'
  has_one :active_sale, through: :active_sale_item, source: :sale

  has_many :carts, dependent: :destroy

  after_create :upload_to_cloudinary


  validates :name, :product_image, :description, :short_description, presence: true
  validates :price, :format => { :with => /\A\d+(?:\.\d{0,2})?\z/ }, :numericality => {:greater_than_or_equal_to => 0}
  validates_length_of :product_galleries, maximum: 5, :too_long => 'maximum 5 images are allowed.'

  validates_length_of :price, maximum: 6, presence: true
  validates_length_of :quantity, maximum: 6, presence: true


  validates :quantity, numericality: {greater_than_or_equal_to: 0}

  validates :image_url, :url => true, allow_blank: true
  validates :link_url, :url => true, allow_blank: true
  validates :cloudinary_url, :url => true, allow_blank: true

  after_create :upload_to_cloudinary

  default_scope { includes(:sale) }

  scope :filter_by_brand, ->(id) { where(product_brand_id: id) }
  scope :filter_by_shampoo, ->(id) { where(shampoo_id: id) }
  scope :filter_by_conditioner, ->(id) { where(conditioner_id: id) }
  scope :filter_by_collection, ->(id) { where(collection_id: id) }
  scope :filter_by_styling_product, ->(id) { where(styling_product_id: id) }
  scope :filter_by_hair_types, ->(id) { joins(:hair_types).where(hair_types: { id: id }) }
  scope :filter_by_categories, ->(id) { joins(:categories).where(categories: { id: id }) }
  scope :filter_by_product_types, ->(id) { joins(:product_types).where(product_types: { id: id }) }
  scope :filter_by_ingredients, ->(id) { joins(:ingredients).where(ingredients: { id: id }) }
  scope :filter_by_preferences, ->(id) { joins(:preferences).where(preferences: { id: id }) }
  scope :filter_by_consistency_types, ->(id) { joins(:consistency_types).where(consistency_types: { id: id }) }
  scope :filter_by_styling_tools, ->(id) { joins(:styling_tools).where(styling_tools: { id: id }) }
  scope :filter_by_price, ->(from,to) { where(:price => from..to) }
  scope :filter_by_sale, ->(id) { joins(:sale).where(sales: { id: id }).where('sales.start_date < :current_time and sales.end_date > :current_time', current_time: Time.now.utc) }

  delegate :discount_percentage, to: :active_sale, allow_nil: true

  class << self
    def search(term)
      where('products.name ilike :query OR products.description ilike :query Or products.short_description ilike :query',
            query: "%#{term}%")
    end

    def filter(data, params)
      data = data.filter_by_categories(params[:categories]) if params[:categories].present?
      data = data.filter_by_hair_types(params[:hair_types]) if params[:hair_types].present?
      data = data.filter_by_product_types(params[:hair_care_product_types]) if params[:hair_care_product_types].present?
      data = data.filter_by_ingredients(params[:ingredients]) if params[:ingredients].present?
      data = data.filter_by_preferences(params[:preferences]) if params[:preferences].present?
      data = data.filter_by_consistency_types(params[:consistency_types]) if params[:consistency_types].present?
      data = data.filter_by_styling_tools(params[:styling_tools]) if params[:styling_tools].present?
      data = data.filter_by_brand(params[:brands]) if params[:brands].present?
      data = data.filter_by_collection(params[:collection]) if params[:collection].present?
      data = data.filter_by_shampoo(params[:shampoo]) if params[:shampoo].present?
      data = data.filter_by_conditioner(params[:conditioner]) if params[:conditioner].present?
      data = data.filter_by_styling_product(params[:styling_product]) if params[:styling_product].present?
      data = data.filter_by_price(params[:price_start], params[:price_end]) if params[:price_start].present? and params[:price_end].present?
      data = data.filter_by_sale(params[:sale]) if params[:sale].present?
      data = data.where(new_arrival: true) if !params[:new_arrival].nil? && [true, false].include?(params[:new_arrival])
      data = data.where(is_trending: true) if !params[:is_trending].nil? && [true, false].include?(params[:is_trending])
      data
    end
  end

  def upload_to_cloudinary
    if image_url
      begin
        image = Cloudinary::Uploader.upload(image_url)
        # :nocov:
        update(cloudinary_url: image['url'])
          # :nocov:
      rescue
      end
    end
  end

  

  def final_price
    return price unless discount_percentage.present?
    price - ((price * discount_percentage)/100)
  end
end
