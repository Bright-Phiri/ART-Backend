class Api::V1::ResultsArchieveController < ApplicationController
   
    def index
        render json: {status: 'success', message: 'results loaded', data: ResultArchieve.all}, status: :ok
    end

    def destroy_all
        ResultArchieve.destroy_all
    end

    private
end