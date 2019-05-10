class Api::V1::EducationsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :set_user
  before_action :set_education, only: [:show, :update, :destroy]

  def index
    educations = @user.educations.page(params[:page]).per(params[:limit])
    render json: educations, meta: pagination_dict(educations)
  end

  def show
    render json: @education
  end

  def update
    if @education.update(education_params)
      render json: @education, status: 201
    else
      render json: { errors: @education.errors }, status: 422
    end
  end

  def create
    education = @user.educations.build(education_params)
    if education.save
      render json: education, status: 201
    else
      render json: { errors: education.errors }, status: 422
    end
  end

  def destroy
    @education.destroy
    head 204
  end

  private

  def education_params
    params.require(:education).permit(:name, :year_from, :year_to, :degree_id, :user_id, :website)
  end

  def set_education
    @education = @user.educations.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
