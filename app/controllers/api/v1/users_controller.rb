# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  skip_before_action :require_login, only: :set_admin
  before_action :set_user, only: [:show, :update, :destroy]
  def index
    users = User.excluding(User.find_by(role: 'Admin'))
    render json: { message: 'users loaded', data: UsersRepresenter.new(users).as_json }, status: :ok
  end

  def show
    render json: { message: 'user loaded', data: UserRepresenter.new(@user).as_json }, status: :ok
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'User successfully added', data: UserRepresenter.new(user).as_json }, status: :created
    else
      render json: { message: 'Failed to add user', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @user.avatar.purge_later unless @user.invalid?
    if @user.update(user_params)
      render json: { message: 'User successfully updated', data: UserRepresenter.new(@user).as_json }, status: :ok
    else
      render json: { message: 'Failed to update user', errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    head :no_content
  end

  def set_admin
    if User.exists?
      render json: { message: 'You dont have required privilege to complete this action' }, status: :forbidden
    else
      user = User.new(user_params.merge(role: 'Admin'))
      if user.save
        render json: { message: 'Account successfully created', data: UserRepresenter.new(user).as_json }, status: :created
      else
        render json: { message: 'Failed to create account', errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:username, :email, :phone, :role, :password, :password_confirmation, :avatar)
  end
end
