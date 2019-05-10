class Api::V1::PreferencesController < ApplicationController
  before_action :authenticate_with_token!, except: [:index]

  def index
    success(data: Preference.all, status: 200)
  end
end

