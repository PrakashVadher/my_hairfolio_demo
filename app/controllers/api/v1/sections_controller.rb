class Api::V1::SectionsController < ApplicationController
  before_action :authenticate_with_token!

  def index
    sections = Section.all
    sections = sections.search(params[:q]) if params[:q].present?
    render json: sections, status: 200
  end

  def create
    section = Section.create!(section_params)
    render json: section, status: 201
  end

  private

  def section_params
    params.require(:section).permit(:name, :description)
  end
end