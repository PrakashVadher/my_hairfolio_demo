# frozen_string_literal: true

module Registrable
  def register_token_and_device_id(user)
    user.generate_authentication_token!
    user.device_id = params[:session][:device_id]
  end
end