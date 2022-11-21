class Api::V1::ResultsController < ApplicationController
    before_action :set_results, only: [:update, :destroy]

    def index
        render json: {status: 'success', message: 'results loaded', data: Result.all}, status: :ok
    end

    def show
        lab_order = LabOrder.find(params[:lab_order_id])
        results = lab_order.result
        if results.nil?
            render json: {status: 'error', message: 'Lab test results not recorded'}
        else
            render json: {status: 'success', message: 'results loaded', data: results}, status: :ok
        end
    end

    def verify
        lab_order = LabOrder.find_by_qrcode!(params[:qrcode])
        if lab_order.valid?
           lab_order.toggle!(:verified)
           render json: {status: 'success', message: 'Lab order verified', data: lab_order}, status: :ok
        else 
           render json: {status: 'error', message: lab_order.errors.where(:base).first.full_message}
        end
    end

    def create
        test_results = AppServices::ResultsUploader.call(results_params)
        if test_results.uploaded?
           render json: {status: 'success', message: 'Test results successfully added to lab order'}  
           NotificationMessageJob.perform_later(test_results.patient_phone, test_results.msg1)
           NotificationMessageJob.perform_later(test_results.patient_phone, test_results.msg2)
        else
            render json: {status: 'error', message: 'Failed to add test results'}
        end
    end

    def update
        if @results.update(results_params)
          render json: {status: 'success', message: 'Test results successfully updated', data: @results}, status: :ok
        else
          render json: {status: 'error', message: 'Failed to update test results', errors: @user.errors.full_messages}
        end
    end

    def destroy
        if @results.destroy
            render json: {status: 'success', message: 'Test results successfully deleted', data: @results}, status: :ok
        else
            render json: {status: 'error', message: 'Failed to delete test results'}
        end
    end

    private

    def set_results 
        lab_order = LabOrder.find(params[:lab_order_id])
        @results = lab_order.result.find(params[:id])
    end

    def results_params
        params.permit(:hiv_res, :tisuue_res, :conducted_by,:qrcode, :blood_type, :tissue_name, :requested_by, :taken_by)
    end
end