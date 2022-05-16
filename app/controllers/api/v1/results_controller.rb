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

    def create
        lab_order = LabOrder.find(params[:lab_order_id])
        result = lab_order.result
        if result.nil?
            patient = Patient.find(lab_order.patient_id)
            patient_full_name = "#{patient.first_name} #{patient.last_name}"
            results = lab_order.create_result(patient_name: patient_full_name, blood_type: lab_order.blood_type, temperature: lab_order.temperature, name: params[:name])
            if results.persisted?
               results_archieve = lab_order.create_result_archieve(patient_name: patient_full_name, blood_type: lab_order.blood_type, temperature: lab_order.temperature, name: params[:name])
               render json: {status: 'success', message: 'Test results successfully added to lab order', data: results}
               results.destroy
               message1 = "Dear #{patient.first_name} #{patient.last_name}, you're being informed that your test results are ready right at the center where the blood samples were taken. therefore, you're requested to come over to the center so that you know your results and get some counseling according to the results."
               message2= "Okondedwa #{patient.first_name} #{patient.last_name}, tafuna tikudziwiseni kuti zotsatila za kuyezedwa kwa magazi anu zafika tsopano ku center komwe munayezedwa magaziko. Muli kupemphedwa kuti mubwere kuti muzamve zotsatilazi komaso kuti mulandire uphungu malingana ndi zotsatilazo."
               phone_number = patient.phone
               TwilioTextMessenger.new(message1,phone_number).send
               TwilioTextMessenger.new(message2,phone_number).send 
            else
              render json: {status: 'error', message: 'Failed to add test results'}
            end
        else
            render json: {status: 'error', message: 'Lab Order Results already added'}
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
        params.permit(:id, :lab_order_id, :name)
    end
end