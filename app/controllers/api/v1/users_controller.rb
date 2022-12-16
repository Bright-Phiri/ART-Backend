# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  skip_before_action :require_login, only: :set_admin
  before_action :set_user, only: [:show, :update, :destroy]
  def index
    users = User.excluding(User.find_by(role: 'Admin'))
    json_response({ message: 'users loaded', data: UserSerializer.new(users).serializable_hash })
  end

  def show
    json_response({ message: 'user loaded', data: UserSerializer.new(@user).serializable_hash })
  end

  def create
    user = User.new(user_params)
    if user.save
      json_response({ message: 'User successfully added', data: UserSerializer.new(user).serializable_hash }, :created)
    else
      json_response({ message: 'Failed to add user', errors: user.errors.full_messages }, :unprocessable_entity)
    end
  end

  def update
    @user.avatar.purge_later unless @user.invalid?
    if @user.update(user_params)
      json_response({ message: 'User successfully updated', data: @user, avatar: url_for(@user.avatar) })
    else
      json_response({ message: 'Failed to update user', errors: @user.errors.full_messages }, :unprocessable_entity)
    end
  end

  def destroy
    if @user.destroy
      json_response({ status: 'success', message: 'User successfully deleted', data: UserSerializer.new(@user).serializable_hash })
    else
      json_response({ status: 'error', message: 'Failed to delete user' }, :bad_request)
    end
  end

  def set_admin
    if User.exists?
      json_response({ message: 'You dont have required privilege to complete this action' }, :bad_request)
    else
      user = User.new(user_params.merge(role: 'Admin'))
      if user.save
        json_response({ message: 'Account successfully created', data: UserSerializer.new(user).serializable_hash })
      else
        json_response({ message: 'Failed to create account', errors: user.errors.full_messages }, :unprocessable_entity)
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
