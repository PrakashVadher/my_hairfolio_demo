module ErrorHandler
  def self.included(clazz)
    clazz.class_eval do
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from Pundit::NotAuthorizedError, with: :not_authorized
      rescue_from ActionController::ParameterMissing, with: :invalid_parameters
      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
      rescue_from Pundit::NotAuthorizedError, with: :not_authorized
      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
      rescue_from Stripe::CardError, with: :stripe_card_error
      rescue_from Errors::QuantityExceedError, with: :quantity_exceed
      rescue_from Errors::CartEmptyError, with: :empty_cart
      rescue_from Errors::CardExistError, with: :card_exist_error
      rescue_from Stripe::InvalidRequestError, with: :stripe_error
      rescue_from Stripe::AuthenticationError, with: :stripe_error
      rescue_from Stripe::StripeError, with: :stripe_error
      rescue_from Stripe::RateLimitError, with: :stripe_error
      rescue_from Errors::BankAccountExistError, with: :bank_account_exist_error
    end
  end

  def standard_error
    unless Rails.env.development?
      render json: { error: I18n.t('errors.standard_error') }, status: 500
    end
  end

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def not_authorized
    render json: { error: I18n.t('errors.not_authorized') }, status: :forbidden
  end

  def record_invalid(object)
    render json: { errors: object.record.errors.full_messages }, status: :unprocessable_entity
  end

  def invalid_parameters(params)
    message ||= I18n.t('errors.param_invalid')
    render json: { error: message }, status: :unprocessable_entity
  end

  def quantity_exceed(error)
    render json: { errors: error.message }, status: :unprocessable_entity
  end

  def empty_cart(error)
    render json: { errors: error.message }, status: :unprocessable_entity
  end

  def card_exist_error(error)
    render json: { errors: error.message }, status: :unprocessable_entity
  end

  def stripe_error(error)
    Rails.logger.debug("Stripe Error: #{error}")
    render json: { errors: error.message }, status: :unprocessable_entity
  end

  def stripe_card_error(error)
    Rails.logger.debug("Stripe Card Error: #{error}")
    render json: { errors: error.message }, status: :unprocessable_entity
  end

  def bank_account_exist_error(error)
    render json: { errors: error.message }, status: :unprocessable_entity
  end
end