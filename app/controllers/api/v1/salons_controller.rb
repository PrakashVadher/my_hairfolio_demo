class Api::V1::SalonsController < ApplicationController
  before_action :set_salon, only: [:update, :show, :destroy, :stylists]
  before_action :authenticate_with_token!, only: [:index, :stylists, :update]
  before_action :authorize_owner, only: :update

  def index
    @blocked_ids = current_user.blocking.pluck(:id)
    salons = Salon.where(nil)
    salons = salons.near([params[:latitude], params[:longitude]], params[:radius]) if (params[:latitude] && params[:longitude] && params[:radius])
    salons = salons.near(params[:zipcode]) if params[:zipcode]
    salons = salons.where("name ilike ? or info ilike ?", "%#{params[:q]}%", "%#{params[:q]}%")
    users = User.unscoped.where(salon_id: salons.pluck(:id)).where.not(id: @blocked_ids)
    users = Kaminari.paginate_array(users).page(params[:page]).per(params[:limit])
    render json: users.empty? ? {users: []} : users, meta: pagination_dict(users), each_serializer: UserNestedSerializer
  end

  def show
    render json: @salon, serializer: SalonDetailSerializer
  end

  def create
    salon = Salon.new(salon_params)
    if salon.save
      render json: salon, status: 201
    else
      render json: { errors: salon.errors }, status: 422
    end
  end

  def update
    if @salon.update(salon_update_params)
      render json: @salon, serializer: SalonDetailSerializer, status: 201
    else
      render json: { errors: @salon.errors }, status: 422
    end
  end

  def destroy
    @salon.destroy
    head 204
  end

  def stylists
    render json: @salon.users.where.not(id: current_user.blocking.pluck(:id))
  end

  def fetch_all
    salons = Salon.all
    salons = salons.search(params[:q]) if params[:q]
    salons = Salon.with_distance_to([params[:latitude], params[:longitude]]).order("distance") if params[:latitude] && params[:longitude]
    salons = salons.paginate(pagination_params)
    success(data: salons, status: 200, meta: pagination_dict(salons))
  end

  private

  def set_salon
    @salon = Salon.find(params[:id])
  end

  def salon_params
    params.require(:salon).permit(:name, :info, :address, :city, :state, :zip, :website, :phone,
                                  :latitude, :longitude, :price_range, :rating, :specialities,
                                  salon_services_attributes: [:name, :description, :price],
                                  salon_business_infos_attributes: [:info_name, :info_value],
                                  salon_timings_attributes: [:week_day, :open_time, :close_time, :is_closed],
                                  salon_images_attributes: [:image_url], section_ids: [])
  end

  def salon_update_params
    params.require(:salon).permit(:name, :info, :address, :city, :state, :zip, :website, :phone,
                                  :latitude, :longitude, :price_range, :rating, :specialities,
                                  salon_services_attributes: [:id, :name, :description, :price, :_destroy],
                                  salon_business_infos_attributes: [:id, :info_name, :info_value, :_destroy],
                                  salon_timings_attributes: [:id, :week_day, :open_time, :close_time, :is_closed, :_destroy],
                                  salon_images_attributes: [:id, :image_url, :_destroy], section_ids: [],
                                  owner_attributes: [:id, :email, :avatar_cloudinary_id, :avtar_url, :career_opportunity, :password, certificate_ids: [], experience_ids: []])
  end

  def authorize_owner
    authorize @salon
  end
end
