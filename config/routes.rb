Rails.application.routes.draw do
  devise_for :users, controllers: {
  registrations: "users/registrations"
}
  get "/run_seed", to: "seeds#run"

  # Root route
  root "movies#index"

  # Movies routes with nested comments
  resources :movies do
    resources :comments, only: [ :create, :destroy ]
    collection do
      get :search
      post :fetch_ai_data
      post :create_from_ai
    end
  end

  # Categories routes
  resources :categories, only: [ :index, :show ]

  # Movie imports routes (for CSV upload)
  resources :movie_imports, only: [ :index, :new, :create, :show ]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
