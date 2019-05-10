class PagesController < ApplicationController

	def show
	    @page = Page.find_by_slug(params[:slug])

	    if @page
	    	render json: @page, status:200
	    else
	    	render json: {errors: "Not Found" }, status:422 
	    end
	end

end
