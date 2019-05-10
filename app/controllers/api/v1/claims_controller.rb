# frozen_string_literal: true

class Api::V1::ClaimsController < ApplicationController
  def create
    @claim = Claim.create!(claim_params)
    success(data: { message: I18n.t('claims.created') }, status: 200)
  end

  private

  def claim_params
    params.require(:claim).permit(:salon_id, :email, :contact_number)
  end
end