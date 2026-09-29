Crm::Engine.routes.draw do
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
