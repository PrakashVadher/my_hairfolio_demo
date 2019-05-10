class Api::V1::ContactsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :set_contact, only: [:update, :destroy, :show]

  def index
    contacts = current_user.contacts.order_desc.page(params[:page]).per(params[:limit])
    render json: contacts, meta: pagination_dict(contacts)
  end

  def show
    render json: @contact
  end

  def update
    if @contact.update(contact_params)
      render json: @contact, status: 201
    else
      render json: {errors: @contact.errors}, status: 422
    end
  end

  def create
    contact = current_user.contacts.build(contact_params)
    if contact.save
      render json: contact, status: 201
    else
      render json: {errors: contact.errors}, status: 422
    end
  end

  def destroy
    @contact.destroy
    head 204
  end

  private

  def set_contact
    @contact = current_user.contacts.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :address, :city, :state, :country_code , :zipcode, :asset_url, :company, post_ids: [], phones_attributes: [:number, :id, :_destroy, :phone_type, :contact_id], emails_attributes: [:email, :id, :_destroy, :contact_id, :email_type])
  end
end
