# frozen_string_literal: true

module Response
  def json_response(object)
    render json: object
  end
end
