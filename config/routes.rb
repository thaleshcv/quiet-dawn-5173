Rails.application.routes.draw do
  resources :investments

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :assets, only: %i[index show] do
    get "accumulated_series", on: :member
  end

  get "home", to: "home#index"

  root "investments#index"
end
