class Api::V1::BlogsController < ApplicationController

	def index
		blogs = Blog.all.paginate(pagination_params)
		success(data: blogs, status: 200, meta: pagination_dict(blogs))
	end

	def show
		blog = Blog.find(params[:id])
		success(data: blog, status: 200)
	end
end