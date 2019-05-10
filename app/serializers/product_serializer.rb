class ProductSerializer < ActiveModel::Serializer
	class RelatedProductSerializer < ActiveModel::Serializer
		attributes :id, :name, :price, :description, :short_description, :product_image,:product_thumb, :discount_percentage, :final_price, :is_favourite, :quantity

		def product_image
			object.product_image.url
		end

		def product_thumb
			object.product_image.prod_thumb_image.url
		end

		def is_favourite
			object.favourites.pluck(:user_id).include?(current_user_id)
		end

		def current_user_id
			@instance_options[:user_id]
		end

	end

	attributes :id, :name,:product_thumb, :is_favourite, :is_trending, :new_arrival, :price, :short_description, :description, :product_image, :quantity,:favourites_count, :link_url, :image_url, :cloudinary_url, :created_at, :categories, :final_price, :discount_percentage
	belongs_to :tag
	belongs_to :product_brand
	has_many :product_galleries
	has_many :hair_types
	has_many :product_types
	has_many :ingredients
	has_many :preferences
	has_many :styling_tools
	has_many :consistency_types
	has_many :related_products, if: :return_related_products?, serializer: RelatedProductSerializer
	belongs_to :collection
	belongs_to :shampoo
	belongs_to :conditioner
	belongs_to :styling_product

	def product_thumb
		object.product_image.prod_thumb_image.url
	end

	def is_favourite
		object.favourites.pluck(:user_id).include?(current_user_id)
	end

	def current_user_id
		@instance_options[:user_id]
	end

	def product_image
		object.product_image.url
	end

	def return_related_products?
		@instance_options.dig(:options, :append_related_products)
	end
end
