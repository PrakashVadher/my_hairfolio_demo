class OrderDetailSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :product_id, :quantity, :price, :discount
  belongs_to :product, seralizer: ProductSerializer

  class ProductSerializer < ActiveModel::Serializer
    attributes :id, :name, :price, :quantity, :product_image, :product_thumb
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
