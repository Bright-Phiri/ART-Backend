Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users
      post 'createaccount', action: :set_admin, controller: 'users'
      resources :patients do 
        resources :lab_orders, except: :index do 
          resources :results, except: :index
        end
      end
      get 'lab_orders', action: :index, controller: 'lab_orders'
      get 'results', action: :index, controller: 'results'
    end
  end
end
