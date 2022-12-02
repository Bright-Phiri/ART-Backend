# frozen_string_literal: true

class Api::V1::LabOrdersController < ApplicationController
  before_action :set_lab_order, only: %i[update destroy]
  def index
    json_response({ status: 'success', message: 'lab orders loaded', data: LabOrder.verified_lab_orders })
  end

  def archived
    json_response({ status: 'success', message: 'lab orders loaded', data: LabOrder.unverified_lab_orders })
  end

  def show
    patient = Patient.find(params[:patient_id])
    lab_orders = patient.lab_orders
    if lab_orders.empty?
      json_response({ status: 'error', message: 'Lab orders not recorded for this patient' })
    else
      json_response({ status: 'success', message: 'Lab orders loaded', data: lab_orders })
    end
  end

  def create
    patient = Patient.find(params[:patient_id])
    lab_order = patient.lab_orders.create(lab_order_params)
    if lab_order.persisted?
      json_response({ status: 'success', message: 'lab order successfully added to patient', data: lab_order })
    else
      json_response({ status: 'error', message: 'Failed to add lab order', errors: lab_order.errors.full_messages })
    end
  end

  def update
    if @lab_order.update(lab_order_params)
      json_response({ status: 'success', message: 'lab order successfully updated', data: @lab_order })
    else
      json_response({ status: 'error', message: 'Failed to update lab order', errors: @lab_order.errors.full_messages })
    end
  end

  def destroy
    if @lab_order.destroy
      json_response({ status: 'success', message: 'Lab order successfully deleted', data: lab_order })
    else
      json_response({ status: 'error', message: 'Failed to delete lab order' })
    end
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
