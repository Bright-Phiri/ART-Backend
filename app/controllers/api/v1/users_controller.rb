class Api::V1::UsersController < ApplicationController
    before_action :authorized, except: [:set_admin, :login]
    before_action :set_user, only: [:show, :update, :change_password, :destroy]
    
    def index
        render json: {status: 'success', message: 'users loaded', data: UserSerializer.new(User.where.not(role: 'Admin'))}, status: :ok
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
        if @user.update(user_params)
            render json: {status: 'success', message: 'User successfully updated', data: UserSerializer.new(@user)}, status: :ok
        else
            render json: {status: 'error', message: 'Failed to update user', errors: @user.errors.full_messages}
        end
    end

    def destroy
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
        begin
           if User.exists?
             @user = User.find_by_username!(params[:username]) #Getting dynamic finder to raise exception
             if @user && @user.authenticate(params[:password])
               token = encode_token({user_id: @user.id})
               render json: {status: 'success', message: 'Access granted', user: @user, token: token}, status: :ok
             else
               render json: {status: 'error', message: "Invalid username or password"}
             end
          else
           render json: {status: 'error', message: "No user account found"}
          end
       rescue ActiveRecord::RecordNotFound
           render json: {status: 'error', message: "Username not found"}
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
        params.permit(:username, :email, :phone, :role, :password, :password_confirmation)
    end
end