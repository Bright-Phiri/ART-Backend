class Api::V1::UsersController < ApplicationController
    skip_before_action :require_login, only: [:set_admin]
    before_action :set_user, only: [:show, :update, :destroy]
    
    def index
        render json: {status: 'success', message: 'users loaded', data: UserSerializer.new(User.excluding(User.find_by role: 'Admin')).serializable_hash}, status: :ok
    end

    def show
        render json: {status: 'success', message: 'user loaded', data: UserSerializer.new(@user).serializable_hash}, status: :ok
    end

    def create
        user = User.new(user_params)
        if user.save
           render json: {status: 'success', message: 'User successfully added', data: UserSerializer.new(user).serializable_hash}, status: :created
        else
            render json: {status: 'error', message: 'Failed to add user', errors: user.errors.full_messages}
        end
    end

    def update
        @user.avatar.purge_later
        if @user.update(user_params)
            render json: {status: 'success', message: 'User successfully updated', data: @user,avatar: url_for(@user.avatar)}, status: :ok
        else
            render json: {status: 'error', message: 'Failed to update user', errors: @user.errors.full_messages}
        end
    end

    def destroy
        @user.avatar.purge_later
        if @user.destroy
            render json: {status: 'success', message: 'User successfully deleted', data: UserSerializer.new(@user).serializable_hash}, status: :ok
        else
            render json: {status: 'error', message: 'Failed to delete user'}
        end
    end

    def set_admin
        if User.exists?
            render json: {status: 'error', message: 'You dont have required privilege to complete this action'}
        else
            user = User.new(user_params.merge(role: 'Admin'))
            if user.save
                render json: {status: 'success', message: 'Account successfully created', data: UserSerializer.new(user).serializable_hash}, status: :created
            else
                render json: {status: 'error', message: 'Failed to create account', errors: user.errors.full_messages}
            end
        end
    end

   private
   def set_user
    @user = User.find(params[:id])
   end

   def user_params
       params.permit(:username, :email, :phone, :role, :password, :password_confirmation, :avatar)
   end
end