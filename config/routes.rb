Pohody::Application.routes.draw do

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