class Api::V1::RefersController < ApplicationController	
	before_action :check_user
	#Meta tags Api
  	def view_post_meta
  		user_id = Post.find(params[:id]).user_id
	    if Refer.exists?(user_id: user_id,post_id: params[:id])
	    	@unique_code = Refer.where(user: user_id,post_id: params[:id]).first.unique_code
	    else
	    	@unique_code = SecureRandom.hex(7)
	    	Refer.create(user_id: user_id, post_id:params[:id], unique_code:@unique_code) if user_id && params[:id]
	    end
	    @post = Post.find(params[:id])
	    set_meta_tags description: @post.description,
	    refresh:5,
	    og:{
	      title: @post.description,
	      description: @post.description,
	      type: "website",
	      url: "",
	      image:@post.photos.first.asset_url
	    }
	end 

	def check_refer_code
		if Refer.exists?( unique_code: params[:unique_code] )
			response = Refer.joins(:refer_histories).where(refers: {unique_code: params[:unique_code]}, refer_histories: { user_id:  @current_user.id }).any? 
			if response
				render json: {errors: "You can not use unique code more than one time"}, status:422
			else
				render json: {message: "Success" }, status: 200
			end
		else
			render json: {errors: "Invalide Unique Code"}, status:422
		end
	end

end
