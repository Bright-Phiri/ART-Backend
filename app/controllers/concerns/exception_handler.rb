# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern
  class InvalidUsername < StandardError; end
  class InvalidEmail < StandardError; end
  class LabOrderError < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |exception|
      json_response({ message: exception.message }, :not_found)
    end

    rescue_from ExceptionHandler::InvalidUsername do |exception|
      json_response({ message: exception.message }, :not_found)
    end

    rescue_from ExceptionHandler::InvalidEmail do |exception|
      json_response({ message: exception.message }, :not_found)
    end

    rescue_from ExceptionHandler::LabOrderError do |exception|
      json_response({ message: exception.message }, :bad_request)
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      json_response({ message: exception.message }, :unprocessable_entity)
    end

    rescue_from Twilio::REST::TwilioError do |exception|
      json_response({ message: exception.message }, :bad_request)
    end
  end
end
