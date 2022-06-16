class Api::V1::ReportsController < ApplicationController
    def stati
        render json: {status: 'success', users: User.where.not(role: 'Admin').count, patients: Patient.count,lab_orders: LabOrder.active_status.count, results: Result.count}, status: :ok
    end

    def lab_orders_statistics
        lab_orders = LabOrder.select(:id, :created_at, 'COUNT(id)').group(:id)
        render json: {status: 'success', lab_orders: lab_orders}, status: :ok
    end
end