module ExceptionHandler 
    extend ActiveSupport::Concern
    class InvalidUsername < StandardError; end
    class LabOrderError < StandardError; end

    included do
        rescue_from ActiveRecord::RecordNotFound do |exception|
            render json: { status: 'error', message: exception.message }
        end

        rescue_from ExceptionHandler::InvalidUsername do |exception|
            render json: { status: 'error', message: exception.message }
        end

        rescue_from StandardError do |exception|
            render json: { status: 'error', message: exception.message }
        end

        rescue_from ExceptionHandler::LabOrderError do |exception|
            render json: { status: 'error', message: exception.message }
        end 

        rescue_from ActiveRecord::RecordInvalid do |exception|
            render json: { status: 'error', message: exception.message }
        end

        rescue_from Twilio::REST::TwilioError do |exception|
            render json: { status: 'error', message: exception.message }
        end
    end
end
