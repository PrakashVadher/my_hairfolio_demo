class Api::V1::CardsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :set_card, only: %i[make_primary destroy]

  def index
    result = fetch_cards(limit: params[:limit], starting_after: params[:starting_after])
    success(data: result, status: 200)
  end

  def create
    @card = Payments::AddCardService.new(user: @current_user, card_params: card_params).call
    success(data: @card)
  end

  def destroy
    return errors(message: I18n.t('errors.primary_card'), status: 422) if @card.is_primary
    StripeIntegrator::Card.new(user: @current_user).delete_card(@card.stripe_card_id)
    @card.destroy!
    success(data: { message: 'Deleted Successfully' }, status: 200)
  end

  def make_primary
    ActiveRecord::Base.transaction do
      @current_user.cards.update_all(is_primary: false)
      @card.update(is_primary: true)
      StripeIntegrator::Customer.new(user: @current_user).update(card: @card.stripe_card_id)
    end
    success(data: { message: 'Updated Successfully' }, status: 200)
  end

  private

  def set_card
    @card = @current_user.cards.find(params[:id])
  end

  def fetch_cards(limit: nil, starting_after: nil)
    return { cards: [], has_more: false } unless @current_user.stripe_customer_id

    cards_array = []
    cards = StripeIntegrator::Card.new(user: @current_user).list_cards(limit: limit, starting_after: starting_after)
    return {} unless cards.present?
    @cards = @current_user.cards
    cards['data'].each do |card_data|
      card = @cards.find_by(stripe_card_id: card_data['id'])
      card_number = '*' * 12 + card_data['last4']
      card_hash = { id: card.id, is_primary: card.is_primary, card_number: card_number,
                    exp_month: card_data['exp_month'], exp_year: card_data['exp_year'],
                    brand: card_data['brand']}
      cards_array << card_hash
    end
    { cards: cards_array, has_more: cards['has_more'] }
  end

  def card_params
    params.require(:card).permit(:number, :expiry_month, :expiry_year, :cvc)
  end
end