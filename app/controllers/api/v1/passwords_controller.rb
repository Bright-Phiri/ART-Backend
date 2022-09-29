class Api::V1::PasswordsController < ApplicationController
   before_action :authorized, except: [:forgot, :reset, :change_password]
   before_action :set_user, only: :change_password

   def change
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      if @user.save
          render json: {status: 'success', message: 'Password successfully updated'}, status: :ok
      else
          render json: {status: 'error', message: 'Failed to update password', errors: @user.errors.full_messages}
      end
   end

   def forgot
      user = User.find_by_email(params[:email]) 
      raise StandardError, "Email address not found" unless user.present?
      user.transaction do
        user.generate_password_token!
        UserMailer.with(user: user).password_reset.deliver_later
        render json: {status: 'success', message: 'A reset password link has been sent to your email'}, status: :ok
      end
   end

   def reset
        token = params[:token].to_s
        user = User.find_by(reset_password_token: token)
        if user.present? && user.password_token_valid?
          if user.reset_password!(params[:password], params[:password_confirmation])
            render json: {status: 'success', message: 'Password successfully changed'}, status: :ok
          else
            render json: {status: 'error', message: 'Failed to update password', errors: user.errors.full_messages}
          end
        else
          render json: {status: 'error', message: 'Token not valid or expired. Try generating a new token.'}
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