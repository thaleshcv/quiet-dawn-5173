Rails.application.routes.draw do
  resources :investments

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :assets, only: %i[index show] do
    get "accumulated", on: :member
  end

  get "home", to: "home#index"

  get "explore", to: "explore#index", as: :explore
  get "explore/prices", to: "explore#prices", as: :explore_prices

  root "investments#index"
end
