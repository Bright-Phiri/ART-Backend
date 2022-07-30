class Api::V1::UsersController < ApplicationController
    before_action :authorized, except: [:set_admin, :login, :forgot, :reset]
    before_action :set_user, only: [:show, :update, :change_password, :destroy]
    
    def index
        render json: {status: 'success', message: 'users loaded', data: UserSerializer.new(User.excluding(User.find_by role: 'Admin'))}, status: :ok
    end

    def show
        render json: {status: 'success', message: 'user loaded', data: UserSerializer.new(@user)}, status: :ok
    end

    def create
        user = User.new(user_params)
        if user.save
           render json: {status: 'success', message: 'User successfully added', data: UserSerializer.new(user)}, status: :created
        else
            render json: {status: 'error', message: 'Failed to add user', errors: user.errors.full_messages}
        end
    end

    def update
        @user.avatar.purge
        if @user.update(user_params)
            render json: {status: 'success', message: 'User successfully updated', data: @user, avatar: url_for(@user.avatar)}, status: :ok
        else
            render json: {status: 'error', message: 'Failed to update user', errors: @user.errors.full_messages}
        end
    end

    def destroy
        @user.avatar.purge
        if @user.destroy
            render json: {status: 'success', message: 'User successfully deleted', data: UserSerializer.new(@user)}, status: :ok
        else
            render json: {status: 'error', message: 'Failed to delete user'}
        end
    end

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

    def set_admin
        if User.exists?
            render json: {status: 'error', message: 'You dont have required privilege to complete this action'}
        else
            user = User.new(user_params)
            user.role = "Admin"
            if user.save
                render json: {status: 'success', message: 'Account successfully created', data: UserSerializer.new(user)}, status: :created
            else
                render json: {status: 'error', message: 'Failed to create account', errors: user.errors.full_messages}
            end
        end
    end

    # LOGGING IN
    def login
        if User.exists?
           @user = User.find_by_username(params[:username])
           raise StandardError.new("Username not found") unless @user.present?
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
    
    def set_user
       @user = User.find(params[:id])
    end

   def user_params
       params.permit(:username, :email, :phone, :role, :password, :password_confirmation, :token, :avatar)
   end
end