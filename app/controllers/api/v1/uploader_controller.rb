require 'aws-sdk-s3'
class Api::V1::UploaderController < ApplicationController

	def create

		file = uploader_params[:image_url]
		if uploader_params[:folder_name]
			file_folder = uploader_params[:folder_name]
			file_name =   "#{file_folder}/#{rand 199999..199999999}_#{file.original_filename}"
		else
			file_name =   "#{rand 199999..199999999}_#{file.original_filename}"
		end
		upload_file = file.tempfile
		aws_secret_access_key = ENV['HAIRFOLIO_AWS_ACCESS_KEY']
		aws_secret_access_key_id = ENV['HAIRFOLIO_AWS_SECRET_ACCESS_KEY']
		aws_regions = ENV['HAIRFOLIO_AWS_REGION']
		s3 = Aws::S3::Resource.new(region: aws_regions,access_key_id: aws_secret_access_key, secret_access_key: aws_secret_access_key_id )

		obj = s3.bucket('hairfolioapp').object(file_name)
		obj.upload_file(upload_file, { acl: 'public-read' })
		# Returns Public URL to the file
		obj.public_url
		image_obj =  {'image_url' => {'url' => obj.public_url} }
		success(data: image_obj, status: 200)
	end

	def video
		file = uploader_params[:video_url]
		if uploader_params[:folder_name]
			file_folder = uploader_params[:folder_name]
			file_name =   "video/#{file_folder}/#{rand 199999..199999999}_#{file.original_filename}"
		else
			file_name =   "#{rand 199999..199999999}_#{file.original_filename}"
		end
		upload_file = file.tempfile
		aws_secret_access_key = ENV['HAIRFOLIO_AWS_ACCESS_KEY']
		aws_secret_access_key_id = ENV['HAIRFOLIO_AWS_SECRET_ACCESS_KEY']
		aws_regions = ENV['HAIRFOLIO_AWS_REGION']
		s3 = Aws::S3::Resource.new(region: aws_regions,access_key_id: aws_secret_access_key, secret_access_key: aws_secret_access_key_id )

		obj = s3.bucket('hairfolioapp').object(file_name)
		obj.upload_file(upload_file, { acl: 'public-read' })
		# Returns Public URL to the file
		video_obj =  {'video_url' => {'url' => obj.public_url} }
		success(data: video_obj, status: 200)
	end

	private

	def uploader_params
		params.require(:uploader).permit(:image_url, :folder_name, :video_url)
	end
end
