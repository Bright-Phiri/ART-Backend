Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users
      post 'createaccount', action: :set_admin, controller: 'users'
      put 'changepassword/:id', action: :change_password, controller: 'users'
      post 'login', action: :login, controller: 'users'
      resources :patients do 
        resources :lab_orders, except: :index do 
          resources :results, except: :index
        end
      end
      resources :results_archieve, only: :index
      delete 'delete_all', action: :destroy_all, controller: 'results_archieve'
      get 'lab_orders', action: :index, controller: 'lab_orders'
      get 'results', action: :index, controller: 'results'
      get 'statistics', action: :stati, controller: 'reports'
      get 'lab_orders_statistics', action: :lab_orders_statistics, controller: 'reports'
    end
  end
end
