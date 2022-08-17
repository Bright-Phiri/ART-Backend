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

    def verify_lab_order 
        lab_order = LabOrder.find_by_qrcode!(params[:qrcode])
        lab_order.update(verified: true)
        render json: {status: 'success', message: 'Lab order verified', data: lab_order}, status: :ok
    end

    def create
        ActiveRecord::Base.transaction do
          lab_order = LabOrder.find(params[:lab_order_id])
          if lab_order.verified?
             result = lab_order.result
             raise LabOrdeError, "Lab Order Results already added" unless result.nil?
             patient = Patient.find(lab_order.patient_id)
             patient_full_name = "#{patient.first_name} #{patient.last_name}"
             results = lab_order.create_result(patient_name: patient_full_name, blood_type: lab_order.blood_type, hiv_res: params[:hiv_res], tisuue_res: params[:tisuue_res], conducted_by: params[:conducted_by])
             if results.persisted?
                lab_order.archived_status!
                message1 = "Dear #{patient_full_name}, you're being informed that your test results are ready at the center where the blood samples were taken. therefore, you're requested to come over so that you know your results and get counseling according to the results."
                message2 = "Okondedwa #{patient_full_name}, tafuna tikudziwiseni kuti zotsatila za kuyezedwa kwa magazi anu zafika tsopano ku center komwe munayezedwa magaziko. Muli kupemphedwa kuti mubwere kuti muzamve zotsatilazi komaso kuti mulandire uphungu malingana ndi zotsatilazo."
                TwilioSms(patient.phone, message1).call
                TwilioSms(patient.phone, message2).call
                render json: {status: 'success', message: 'Test results successfully added to lab order', data: results}  
             end
           else
             render json: {status: 'error', message: 'Lab Order Not verified'}
           end
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
        @results = Result.find(params[:id])
    end

    def results_params
        params.permit(:lab_order_id, :hiv_res, :tisuue_res, :conducted_by,:qrcode, :blood_type, :tissue_name, :requested_by, :taken_by)
    end
end