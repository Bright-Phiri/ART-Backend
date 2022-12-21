# frozen_string_literal: true

class Api::V1::PasswordsController < ApplicationController
  skip_before_action :require_login, only: [:forgot, :reset, :change]
  before_action :set_user, only: :change

  def change
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    if @user.save
      render json: { message: 'Password successfully updated' }, status: :ok
    else
      render json: { message: 'Failed to update password', errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def forgot
    user = User.find_by(email: params[:email])
    raise InvalidEmail, 'Email address not found' unless user.present?

    user.transaction do
      user.generate_password_token!
      UserMailer.with(user:).password_reset.deliver_later
      render json: { message: 'A reset password link has been sent to your email' }, status: :Ok
    end
  end

  def reset
    user = User.find_by(reset_password_token: token)
    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password], params[:password_confirmation])
        render json: { message: 'Password successfully changed' }, status: :ok
      else
        render json: { message: 'Failed to update password', errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Token not valid or expired. Try generating a new token.' }, status: :bad_request
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:username, :email, :password, :password_confirmation, :token)
  end
end
