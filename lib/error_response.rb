# frozen_string_literal: true

class ErrorResponse
  attr_accessor :message, :errors, :code
  def initialize(message: nil, errors: [], code: nil)
    @message = message
    @errors = errors
    @code = code
  end

  def success?
    false
  end
end