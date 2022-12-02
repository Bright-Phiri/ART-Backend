# frozen_string_literal: true

class Api::V1::SessionsController < ApplicationController
  skip_before_action :require_login, only: :login
  def login
    if User.exists?
      @user = User.find_by(username: params.fetch(:username).strip)
      raise InvalidUsername, 'Username not found' unless @user.present?

      if @user&.authenticate(params[:password])
        token = encode_token({ user_id: @user.id })
        json_response({ status: 'success', message: 'Access granted', user: @user, token:, avatar: url_for(@user.avatar) })
      else
        json_response({ status: 'error', message: 'Invalid username or password' })
      end
    else
      json_response({ status: 'error', message: 'No user account found' })
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
