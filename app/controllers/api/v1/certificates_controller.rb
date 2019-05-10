class Api::V1::CertificatesController < ApplicationController

  def index
    certificates = Certificate.all.page(params[:page]).order('position asc').per(params[:limit])
    render json: certificates, meta: pagination_dict(certificates)
  end

  def show
    render json: Certificate.find(params[:id])
  end

  def create
    certificate = Certificate.new(certificate_params)
    if certificate.save
      render json: certificate, status: 201
    else
      render json: { errors: certificate.errors.full_messages }, status: 422
    end
  end

   private

   def certificate_params
     params.require(:certificate).permit(:name)
   end
end
