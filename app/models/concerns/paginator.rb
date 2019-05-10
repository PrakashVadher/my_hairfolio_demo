# frozen_string_literal: true

module Paginator
  extend ActiveSupport::Concern

  class_methods do
    def paginate(params)
      page(params[:page]).per(params[:per_page])
    end
  end
end