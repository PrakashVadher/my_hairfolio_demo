class CartSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :product_id, :units, :created_at, :updated_at, :product, :unique_codes
  belongs_to :product, seralizer: ProductSerializer

  def units
  	object.quantity
  end

  def unique_codes
    object.cart_unique_codes.pluck(:unique_code)
  end

  class ProductSerializer < ActiveModel::Serializer
    attributes :id, :name, :price, :quantity,:product_thumb, :product_image, :discount_percentage, :final_price
    belongs_to :product_brand
    has_many :product_galleries
    belongs_to :tag

    def product_image
      { url: object.product_image.url }
    end

    def product_thumb
      object.product_image.prod_thumb_image.url
    end
  end
end
