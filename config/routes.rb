Pohody::Application.routes.draw do

  get "trips" => "trips#index"
  get "trips/:id" => "trips#show"
  post "trips/:id/join" => "trips#join"

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"

  devise_for :users

  resources :users
  namespace :account do
    resources :tracks
    resources :trips
  end
end