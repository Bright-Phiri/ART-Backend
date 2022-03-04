module ExceptionHandler 
    extend ActiveSupport::Concern

    included do
        rescue_from ActiveRecord::RecordNotFound do |e|
            render json: { status: 'error', message: e.message}
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
            render json: { status: 'error', message: e.message}
        end
    end
end
