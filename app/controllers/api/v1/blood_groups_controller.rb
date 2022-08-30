class Api::V1::BloodGroupsController < ApplicationController
    before_action :set_blood_group, only: [:show, :update, :destroy]
    def index
        render json: {status: 'success', message: 'Blood groups loaded', data: BloodGroup.all}, status: :ok
    end

    def show
        render json: {status: 'success', message: 'Blood group loaded', data: @blood_group}, status: :ok
    end

    def create
        blood_group = BloodGroup.new(blood_group_params)
        if blood_group.save 
            render json: {status: 'success', message: 'Blood group successfully added', data: blood_group}, status: :created
        else
            render json: {status: 'error', message: 'Failed to add blood group', errors: blood_group.errors.full_messages}
        end
    end

    def update
        if  @blood_group.update(blood_group_params)
            render json: {status: 'success', message: 'Blood group successfully updated', data: @blood_group}, status: :ok
        else
            render json: {status: 'error', message: 'Failed to update blood group', errors: @blood_group.errors.full_messages}
        end
    end

    def destroy
        if  @blood_group.destroy
            render json: {status: 'success', message: 'Blood group successfully deleted', data: @blood_group}, status: :ok
        else
            render json: {status: 'error', message: 'Failed to deleted blood group'}
        end
    end

    private

    def set_blood_group
        @blood_group = BloodGroup.find(params[:id])
    end

    def blood_group_params
        params.permit(:name)
    end
end