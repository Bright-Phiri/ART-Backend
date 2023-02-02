# frozen_string_literal: true

class Api::V1::LabOrdersController < ApplicationController
  before_action :set_lab_order, only: [:update, :destroy]
  def index
    render json: { message: 'lab orders loaded', data: LabOrdersRepresenter.new(LabOrder.preload(:patient).active_status).as_json }, status: :ok
  end

  def archived
    render json: { message: 'lab orders loaded', data: LabOrdersRepresenter.new(LabOrder.preload(:patient).archived_status).as_json }, status: :ok
  end

  def show
    patient = Patient.preload(:patient).find(params[:patient_id])
    if patient.lab_orders.size.zero?
      render json: { message: 'Lab orders not recorded for this patient' }, status: :not_found
    else
      render json: { message: 'Lab orders loaded', data: LabOrdersRepresenter.new(patient.lab_orders).as_json }, status: :ok
    end
  end

  def create
    patient = Patient.find(params[:patient_id])
    lab_order = patient.lab_orders.create(lab_order_params)
    if lab_order.persisted?
      render json: { message: 'lab order successfully added to patient', data: LabOrderRepresenter.new(lab_order).as_json }, status: :created
    else
      render json: { message: 'Failed to add lab order', errors: lab_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @lab_order.update(lab_order_params)
      render json: { message: 'lab order successfully updated', data: LabOrderRepresenter.new(@lab_order).as_json }, status: :ok
    else
      render json: { message: 'Failed to update lab order', errors: @lab_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @lab_order.destroy!
    head :no_content
  end

  private

  def set_lab_order
    patient = Patient.find(params[:patient_id])
    @lab_order = patient.lab_orders.find(params[:id])
  end

  def lab_order_params
    params.permit(:qrcode, :blood_type, :tissue_name, :requested_by, :taken_by)
  end
end
