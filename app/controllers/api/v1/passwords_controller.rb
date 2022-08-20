class Api::V1::PasswordsController < ApplicationController
   before_action :authorized, except: [:forgot, :reset, :change_password]
   before_action :set_user, only: :change_password

   def change_password
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      if @user.save
          render json: {status: 'success', message: 'User successfully updated', data: UserSerializer.new(@user)}, status: :ok
      else
          render json: {status: 'error', message: 'Failed to update user', errors: @user.errors.full_messages}
      end
   end

   def forgot
        return render json: {status: 'error', message: 'Email not present'} if params[:email].blank? # check if email is present
        user = User.find_by_email(params[:email]) # if present find user by email
        if user
           user.transaction do
              user.generate_password_token! #generate password token
              UserMailer.with(user: user).password_reset.deliver_now
              render json: {status: 'success', message: 'A reset password link has been sent to your email'}, status: :ok
           end
        else
          render json: {status: 'error', message: 'Email Address not found'}
        end
   end

   def reset
        token = params[:token].to_s
        return render json: {status: 'error', message: 'Email not present'} if token.blank?
        user = User.find_by(reset_password_token: token)
        if user.present? && user.password_token_valid?
          if user.reset_password!(params[:password])
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