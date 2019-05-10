class Api::V1::CartsController < ApplicationController
	
	before_action :authenticate_with_token!

	def index		
		@cart = Cart.where(user_id: current_user.id).order(created_at: :desc)
		render json: @cart, status:201
	end

	def create
		if params[:unique_codes].present?
			response = check_valid_unique_code(params[:unique_codes])
			return errors(message: response.message, status: response.code) unless response.success?
		end
		cart = Cart.where(product_id: cart_params[:product_id], user_id: current_user.id)
		quantity = Product.where(id: cart_params[:product_id]).pluck(:quantity)[0]

		if cart_params[:quantity] > quantity
			render json: { errors: "Out Of Stock" }, status: 422
		elsif !cart.empty?
			current_quantity = cart.pluck(:quantity)[0]
			final_quantity = current_quantity + cart_params[:quantity]
			if final_quantity > quantity
				render json: { errors: "Out Of Stock" }, status: 422
			else
				cart.update(quantity: final_quantity )
				assign_unique_code_to_cart(cart.first, params[:unique_codes])
				render json: cart, status:201
			end
		else
			cart = Cart.new(cart_params)
			cart.user_id = current_user.id
			cart.quantity = cart_params[:quantity]
			cart.save
			assign_unique_code_to_cart(cart, params[:unique_codes])
			render json: cart, status:201
		end
	end
	
	def update_cart
		if params[:unique_codes].present?
			response = check_valid_unique_code(params[:unique_codes])
			return errors(message: response.message, status: response.code) unless response.success?
		end
		quantity = Product.where(id: cart_params[:product_id]).pluck(:quantity)[0]

		if cart_params[:quantity] > quantity
			render json: { errors: "Out Of Stock" }, status:422
		else
			cart = Cart.where(product_id: params[:product_id])
			cart = cart.where(user_id: current_user.id)			
			cart.update(quantity: params[:cart][:quantity])
			assign_unique_code_to_cart(cart.first, params[:unique_codes])
			render json: cart, status:200
		end
	end


	def remove_from_cart
		cart = Cart.where(user_id: current_user.id).where(product_id: params[:product_id])
		if cart.destroy_all
			render json: { message: "Success" }, status:201
		else
			render json: { errors: "Error" }, status:422
		end
	end


	private
	def cart_params
		params.require(:cart).permit(:product_id, :quantity)
	end

	def assign_unique_code_to_cart(cart, unique_codes)
		return unless unique_codes.present?
		return unless unique_codes.class == Array

		unique_codes.each do |unique_code|
			refer = Refer.find_by(unique_code: unique_code)
			next unless refer.present?
			if refer.post.product_ids.include? cart.product_id
				unless cart.user.orders.joins(:order_unique_codes).where(order_unique_codes: { refer_id: refer.id }).any?
					cart.cart_unique_codes.find_or_create_by(unique_code: unique_code)
				end
			end
		end
	end

	def check_valid_unique_code(unique_codes)
		raise ActionController::ParameterMissing.new(:unique_codes) unless unique_codes.class == Array
		unique_codes.each do |unique_code|
			refer = Refer.find_by(unique_code: unique_code)
			return ErrorResponse.new(message: 'Invalid unique code', code: 422) unless refer.present?
		end
		SuccessResponse.new
	end
end
