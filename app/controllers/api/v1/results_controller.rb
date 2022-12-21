# frozen_string_literal: true

class Api::V1::ResultsController < ApplicationController
  def index
    render json: { message: 'results loaded', data: Result.all }, status: :ok
  end

  def show
    lab_order = LabOrder.find(params[:lab_order_id])
    results = lab_order.result
    if results.nil?
      render json: { message: 'Lab test results not recorded' }, status: :not_found
    else
      render json: { message: 'results loaded', data: results }, status: :ok
    end
  end

  def verify
    lab_order = LabOrder.find_by_qrcode!(params[:qrcode])
    if lab_order.valid?
      lab_order.toggle!(:verified)
      render json: { message: 'Lab order verified', data: lab_order }, status: :Ok
    else
      render json: { message: lab_order.errors.where(:base).first.full_message }, status: :bad_request
    end
  end

  def create
    test_results = AppServices::ResultsUploader.call(results_params.merge(lab_order_id: params[:lab_order_id]))
    if test_results.uploaded?
      render json: { message: 'Test results successfully added to lab order' }, status: :created
      NotificationMessageJob.perform_later(test_results.patient_phone, test_results.msg1)
      NotificationMessageJob.perform_later(test_results.patient_phone, test_results.msg2)
    else
      render json: { message: 'Failed to add test results' }, status: :bad_request
    end
  end

  def update
    if @results.update(results_params)
      render json: { message: 'Test results successfully updated', data: @results }, status: :ok
    else
      render json: { message: 'Failed to update test results', errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @results.destroy!
    head :no_content
  end

  private

  def set_results
    lab_order = LabOrder.find(params[:lab_order_id])
    @results = lab_order.result.find(params[:id])
  end

  def results_params
    params.permit(:hiv_res, :tisuue_res, :conducted_by, :qrcode, :blood_type, :tissue_name, :requested_by, :taken_by)
  end
end
