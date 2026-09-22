require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "admin/dashboard#index"

  # Déclaration du concern de routes avec ses méthodes attenantes
  concern :searchable do
    collection do
      post :search, defaults: { format: :turbo_stream }
      get :search, defaults: { format: :turbo_stream }
    end
  end

  concern :filterable do
    collection do
      post :filter, defaults: { format: :turbo_stream }
      get :filter, defaults: { format: :turbo_stream }
    end
  end

  namespace :users do
    resource :session
    resources :passwords, param: :token
    resource :registrations, only: %i[new create]
    resource :confirmations, only: %i[show create]
  end

  namespace :admin do
    resources :members, concerns: %i[searchable filterable]
    resources :organizations, concerns: %i[searchable filterable]
    resource :dashboard
    resources :member_types
    resources :investments
    resources :disciplines
    resources :levels
    resources :notes, only: %i[show create update edit destroy]
    get "/member/import", to: "members#import", as: :member_import_form
    post "/member/import", to: "members#import", as: :member_import
    get "/organization/import",
        to: "organizations#import",
        as: :organization_import_form
    post "/organization/import",
         to: "organizations#import",
         as: :organization_import

    get "/notes/new/member/:member_id", to: "notes#new", as: :new_member_note
    get "/notes/new/organization/:organization_id",
        to: "notes#new",
        as: :new_organization_note
    get "/notes/edit/member/:member_id/note/:id",
        to: "notes#edit",
        as: :edit_member_note
    get "/notes/edit/organization/:organization_id/note/:id",
        to: "notes#edit",
        as: :edit_organization_note
  end
end
