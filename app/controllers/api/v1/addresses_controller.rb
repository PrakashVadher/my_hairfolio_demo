class Api::V1::AddressesController < ApplicationController
  
  before_action :authenticate_with_token!
  before_action :set_address, only: [:update, :destroy, :show]  
  
  def index
    @addresses = current_user.addresses
    render json: @addresses, status:200
  end

  def create
  	address = current_user.addresses.build(address_params)
  	if address.save
		render json: address, status:200
  	else
  		render json: {errors: "Error"}, status:422
  	end
  end

  def show
  	render json: @address
  end

  def update
  	if @address.update(address_params)
  		render json: @address.reload, status: 200
  	else
  		render json: {errors: "Error"}, status:422
  	end
  end

  def destroy
    @address.destroy
    head 204
  end

  private
  
  def address_params
  	params.require(:address).permit(:email, :first_name, :last_name, :user_address, :phone, :city, :landmark, :zip_code, :default_address)
  end

  def set_address
  	@address = current_user.addresses.find(params[:id])
  end

end
