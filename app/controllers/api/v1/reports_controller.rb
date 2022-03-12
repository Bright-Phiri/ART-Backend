class Api::V1::ReportsController < ApplicationController
    def stati
        render json: {status: 'success', users: User.where.not(role: 'Admin').count, patients: Patient.count,lab_orders: LabOrder.count, results: Result.count}, status: :ok
    end
end