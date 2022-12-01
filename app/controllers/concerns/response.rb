module Response
    def json_response(object)
        render json: object
    end
end