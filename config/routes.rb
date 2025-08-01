Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "admin/dashboard#index"

  namespace :users do
    resource :session
    resources :passwords, param: :token
    resource :registrations, only: %i[new create]
    resource :confirmations, only: %i[show create]
  end

  namespace :admin do
    resource :dashboard
    resources :member_types
    resources :members
    resources :organizations
    resources :notes, only: %i[show create update edit destroy]
    get "/notes/new/:member_id", to: "notes#new", as: :new_note
  end
end
