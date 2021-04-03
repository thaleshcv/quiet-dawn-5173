Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  unauthenticated do
    get "static/landing", as: :landing
    root "static#landing"
  end

  authenticate :user do
    resources :investments

    resources :assets, only: %i[index show] do
      get "accumulated", on: :member
    end

    resources :reports, only: %i[index show]

    get "explore", to: "explore#index", as: :explore
    get "explore/prices", to: "explore#prices", as: :explore_prices
    get "explore/assets", to: "explore#assets", as: :explore_assets

    root "investments#index", as: :authenticated_root
  end
end
