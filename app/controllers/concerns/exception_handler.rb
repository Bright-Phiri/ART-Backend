module ExceptionHandler 
    extend ActiveSupport::Concern

    included do
        rescue_from ActiveRecord::RecordNotFound do |exception|
            render json: { status: 'error', message: exception.message}
        end

        rescue_from ActiveRecord::RecordInvalid do |exception|
            render json: { status: 'error', message: exception.message}
        end

        rescue_from StandardError do |exception|
            render json: { status: 'error', message: exception.message}
        end

        rescue_from Twilio::REST::TwilioError do |exception|
            render json: { status: 'error', message: exception.message}
        end
    end
end
