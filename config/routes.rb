Rails.application.routes.draw do
  resources :investments
  devise_for :users, controllers: { sessions: "users/sessions" }

  resources :assets, only: %i[index show]

  get "home", to: "home#index"

  root "investments#index"
end
