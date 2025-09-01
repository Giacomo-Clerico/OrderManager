Rails.application.routes.draw do
  get "users/new"
  get "users/create"
  get "users/index"
  devise_for :users, sign_out_via: [ :delete, :get ], skip: [ :registrations ]

  resources :users, only: [ :new, :create, :index ]

  # get "/orders/new", to: "orders#new", as: :new_order
  # get "/orders/:id", to: "orders#show", as: :order
  # post "/orders", to: "orders#create", as: :orders
  # patch "/orders/:id/check", to: "orders#check", as: :check_order

  resources :delivery_notes do
    collection do
      get :find_order
      post :check_order
    end
  end
  resources :products
  resources :storages
  resources :stocks
  resources :orders do
    member do
      patch :check
      patch :refuse
      patch :submit_quote
      patch :approve
      patch :deny
      patch :revise
      patch :restore
    end
    resources :quotes do
      resources :items do
        member do
          patch :select
          patch :unselect
          patch :recommend
          patch :unrecommend
        end
      end
      resources :payments
    end
    resources :delivery_notes do
      resources :goods
    end
    resources :comments
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "orders#index"
end
