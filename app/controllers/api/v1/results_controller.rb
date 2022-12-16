# frozen_string_literal: true

class Api::V1::ResultsController < ApplicationController
  def index
    json_response({ message: 'results loaded', data: Result.all })
  end

  def show
    lab_order = LabOrder.find(params[:lab_order_id])
    results = lab_order.result
    if results.nil?
      json_response({ message: 'Lab test results not recorded' }, :not_found)
    else
      json_response({ message: 'results loaded', data: results })
    end
  end

  def verify
    lab_order = LabOrder.find_by_qrcode!(params[:qrcode])
    if lab_order.valid?
      lab_order.toggle!(:verified)
      json_response({ message: 'Lab order verified', data: lab_order })
    else
      json_response({ message: lab_order.errors.where(:base).first.full_message }, :bad_request)
    end
  end

  def create
    test_results = AppServices::ResultsUploader.call(results_params.merge(lab_order_id: params[:lab_order_id]))
    if test_results.uploaded?
      json_response({ message: 'Test results successfully added to lab order' }, :created)
      NotificationMessageJob.perform_later(test_results.patient_phone, test_results.msg1)
      NotificationMessageJob.perform_later(test_results.patient_phone, test_results.msg2)
    else
      json_response({ message: 'Failed to add test results' }, :bad_request)
    end
  end

  def update
    if @results.update(results_params)
      json_response({ message: 'Test results successfully updated', data: @results })
    else
      json_response({ message: 'Failed to update test results', errors: @user.errors.full_messages }, :unprocessable_entity)
    end
  end

  def destroy
    if @results.destroy
      json_response({ message: 'Test results successfully deleted', data: @results })
    else
      json_response({ message: 'Failed to delete test results' }, :bad_request)
    end
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
