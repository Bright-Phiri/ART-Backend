Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
  namespace :api do
    namespace :v1 do
      resources :users
      post 'createaccount', action: :set_admin, controller: 'users'
      put 'changepassword/:id', action: :change_password, controller: 'users'
      post 'login', action: :login, controller: 'users'
      post 'password/forgot', action: :forgot, controller: 'users'
      post 'password/reset', action: :reset, controller: 'users'
      resources :patients do 
        resources :lab_orders, except: :index do 
          resources :results, except: :index
        end
      end
      delete 'delete_all', action: :destroy_all, controller: 'lab_orders_archieve'
      get 'lab_orders', action: :index, controller: 'lab_orders'
      get 'lab_orders_archieve', action: :archived, controller: 'lab_orders'
      get 'verify_lab_order/:qrcode', action: :verify_lab_order, controller: 'results'
      get 'results', action: :index, controller: 'results'
    end
  end
end
