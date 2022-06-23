class Api::V1::PatientsController < ApplicationController
    before_action :set_patient, only: [:show, :update, :destroy]

    def index
        render json: {status: 'success', message: 'patients loaded', data: Patient.all}, status: :ok
    end

    def show
        render json: {status: 'success', message: 'patient loaded', data: @patient}, status: :ok
    end

    def create
        patient = Patient.new(patient_params)
        if patient.save
           render json: {status: 'success', message: 'patient successfully added', data: patient}, status: :created
        else
            render json: {status: 'error', message: 'Failed to add patient', errors: patient.errors.full_messages}
        end
    end

    def update
        if @patient.update(patient_params)
            render json: {status: 'success', message: 'patient successfully updated', data: @patient}, status: :ok
        else
            render json: {status: 'error', message: 'Failed to update patient', errors: @patient.errors.full_messages}
        end
    end

    def destroy
        if @patient.destroy
            render json: {status: 'success', message: 'patient successfully deleted', data: @patient}, status: :ok
        else
            render json: {status: 'error', message: 'Failed to delete patient'}
        end
    end

    private
    def set_patient
        @patient = Patient.find(params[:id])
    end

    def patient_params
        params.permit(:first_name, :last_name, :gender, :dob, :village, :district, :phone, :location)
    end
end