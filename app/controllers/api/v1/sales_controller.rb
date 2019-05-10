# frozen_string_literal: true

class Api::V1::SalesController < ApplicationController
  def fetch_sale
    sale = Sale.first
    success(data: sale, status: 200)
  end
end