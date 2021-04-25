Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }, path_names: {
    edit: "edit(/:section)"
  }

  unauthenticated do
    get "static/landing", as: :landing
    root "static#landing"
  end

  authenticate :user do
    resources :investments

    resources :items, only: %i[index show] do
      get "accumulated", on: :member
    end

    resources :reports, only: %i[index show]

    get "explore", to: "explore#index", as: :explore
    get "explore/prices", to: "explore#prices", as: :explore_prices
    get "explore/items", to: "explore#items", as: :explore_items

    root "investments#index", as: :authenticated_root
  end
end
