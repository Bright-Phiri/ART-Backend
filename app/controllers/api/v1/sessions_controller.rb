class Api::V1::SessionsController < ApplicationController
    before_action :authorized, except: [:login, :forgot, :reset]

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

    # LOGGING IN
    def login
        if User.exists?
           @user = User.find_by_username(params[:username])
           raise InvalidUsername, "Username not found" unless @user.present?
           if @user && @user.authenticate(params[:password])
              token = encode_token({user_id: @user.id})
              render json: {status: 'success', message: 'Access granted', user: @user, token: token, avatar: url_for(@user.avatar)}, status: :ok
           else
              render json: {status: 'error', message: "Invalid username or password"}
           end
        else
           render json: {status: 'error', message: "No user account found"}
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