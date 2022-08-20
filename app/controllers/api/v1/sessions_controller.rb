class Api::V1::SessionsController < ApplicationController
    before_action :authorized, except: [:login]

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