Rails.application.routes.draw do
  root "sessions#new"

  resources :sessions, only: [:new, :create, :destroy]
  delete "logout", to: "sessions#destroy", as: :logout

  resources :clips, except: [:index]

  get "dashboard", to: "clips#index"
end
