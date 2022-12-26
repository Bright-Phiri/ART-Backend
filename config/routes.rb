# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  namespace :api do
    namespace :v1 do
      resources :patients do
        resources :lab_orders, except: :index do
          resources :results, except: :index
        end
      end
      resources :blood_groups
      resources :users
      get 'lab_orders', action: :index, controller: 'lab_orders'
      get 'lab_orders_archive', action: :archived, controller: 'lab_orders'
      get 'verify_lab_order/:qrcode', action: :verify, controller: 'results'
      get 'results', action: :index, controller: 'results'
      post 'createaccount', action: :set_admin, controller: 'users'
      put 'changepassword/:id', action: :change, controller: 'passwords'
      post 'login', action: :login, controller: 'sessions'
      post 'password/forgot', action: :forgot, controller: 'passwords'
      post 'password/reset', action: :reset, controller: 'passwords'
    end
  end
end
