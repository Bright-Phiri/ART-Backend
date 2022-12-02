# frozen_string_literal: true

class Api::V1::PasswordsController < ApplicationController
  skip_before_action :require_login, only: %i[forgot reset change]
  before_action :set_user, only: :change

  def change
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    if @user.save
      json_response({ status: 'success', message: 'Password successfully updated' })
    else
      json_response({ status: 'error', message: 'Failed to update password', errors: @user.errors.full_messages })
    end
  end

  def forgot
    user = User.find_by(email: params[:email])
    raise InvalidEmail, 'Email address not found' unless user.present?

    user.transaction do
      user.generate_password_token!
      UserMailer.with(user:).password_reset.deliver_later
      json_response({ status: 'success', message: 'A reset password link has been sent to your email' })
    end
  end

  def reset
    user = User.find_by(reset_password_token: token)
    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password], params[:password_confirmation])
        json_response({ status: 'success', message: 'Password successfully changed' })
      else
        json_response({ status: 'error', message: 'Failed to update password', errors: user.errors.full_messages })
      end
    else
      json_response({ status: 'error', message: 'Token not valid or expired. Try generating a new token.' })
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
