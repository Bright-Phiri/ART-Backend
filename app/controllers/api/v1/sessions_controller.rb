# frozen_string_literal: true

class Api::V1::SessionsController < ApplicationController
  skip_before_action :require_login, only: :login
  def login
    if User.exists?
      @user = User.find_by(username: params.fetch(:username).strip)
      raise InvalidUsername, 'Username not found' unless @user.present?

      if @user&.authenticate(params[:password])
        token = encode_token({ user_id: @user.id })
        render json: { message: 'Access granted', user: UserRepresenter.new(@user).as_json, token: token }
      else
        render json: { message: 'Invalid username or password' }, status: :bad_request
      end
    else
      render json: { message: 'No user account found' }, status: :not_found
    end
  end

  def auto_login
    render json: @user
  end

  private

  def user_params
    params.permit(:username, :email, :password, :token)
  end
end
