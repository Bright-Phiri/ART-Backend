# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern
  class InvalidUsername < StandardError; end
  class InvalidEmail < StandardError; end
  class LabOrderError < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { message: exception.message }, status: :not_found
    end

    rescue_from ExceptionHandler::InvalidUsername do |exception|
      render json: { message: exception.message }, status: :not_found
    end

    rescue_from ExceptionHandler::InvalidEmail do |exception|
      render json: { message: exception.message }, status: :not_found
    end

    rescue_from ExceptionHandler::LabOrderError do |exception|
      render json: { message: exception.message }, status: :bad_request
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      render json: { message: exception.message }, status: :unprocessable_entity
    end

    rescue_from ActiveRecord::RecordNotDestroyed do |exception|
      render json: { message: exception.record.errors }, status: :unprocessable_entity
    end

    rescue_from Twilio::REST::TwilioError do |exception|
      render json: { message: exception.message }, status: :service_unavailable
    end
  end
end
