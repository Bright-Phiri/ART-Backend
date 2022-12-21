# frozen_string_literal: true

class Api::V1::BloodGroupsController < ApplicationController
  before_action :set_blood_group, only: [:show, :update, :destroy]
  def index
    render json: { message: 'Blood groups loaded', data: BloodGroup.all }, status: :ok
  end

  def show
    render json: { message: 'Blood group loaded', data: @blood_group }, status: :ok
  end

  def create
    blood_group = BloodGroup.new(blood_group_params)
    if blood_group.save
      render json: { message: 'Blood group successfully added', data: blood_group }, status: :created
    else
      render json: { message: 'Failed to add blood group', errors: blood_group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @blood_group.update(blood_group_params)
      render json: { message: 'Blood group successfully updated', data: @blood_group }, status: :ok
    else
      render json: { message: 'Failed to update blood group', errors: @blood_group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @blood_group.destroy!
    head :no_content
  end

  private

  def set_blood_group
    @blood_group = BloodGroup.find(params[:id])
  end

  def blood_group_params
    params.permit(:name)
  end
end
