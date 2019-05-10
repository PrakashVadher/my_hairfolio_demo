class Api::V1::PaymentsController < ApplicationController

	before_action :authenticate_with_token!

  	def create
	  	# render json: @current_user.auth_token
  	end

end
